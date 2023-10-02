
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

  depends_on = [helm_release.istio_base]
}

// kong

resource "kubernetes_namespace_v1" "kong_istio" {
  metadata {
    name = "kong-istio"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace_v1.kong_istio.metadata.0.name
}
