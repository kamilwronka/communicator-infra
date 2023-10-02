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
    key    = "cluster/istio/terraform.tfstate"
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

resource "kubernetes_manifest" "istio_mtls_config" {
  manifest = yamldecode(templatefile("${path.root}/../../modules/kubernetes/kong-plugins/templates/mtls.tpl", {
    mode : "STRICT"
    namespace = "istio-system"
  }))
}

resource "kubernetes_manifest" "kong_mtls_config" {
  manifest = yamldecode(templatefile("${path.root}/../../modules/kubernetes/kong-plugins/templates/mtls.tpl", {
    mode : "DISABLE"
    namespace = "kong-istio"
  }))
}
