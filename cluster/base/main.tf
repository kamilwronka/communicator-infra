
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }

  backend "s3" {
    bucket = "communicator-tf-state"
    key    = "cluster/base/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "kubernetes" {
  config_path = var.kube_config_path
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

// istio

resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace_v1.istio_system.metadata.0.name
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace_v1.istio_system.metadata.0.name

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }
}

// kong

resource "kubernetes_namespace_v1" "kong" {
  metadata {
    name = "kong"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [
    helm_release.istiod
  ]
}

resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace_v1.kong.metadata.0.name
}

resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  depends_on = [helm_release.kong]
}

resource "helm_release" "cert-manager" {
  name       = "jetstack"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace_v1.cert_manager.metadata.0.name

  set {
    name  = "installCRDs"
    value = true
  }
}
