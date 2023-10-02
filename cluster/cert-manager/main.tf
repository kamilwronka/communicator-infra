
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
    key    = "cluster/cert-manager/terraform.tfstate"
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

resource "kubernetes_manifest" "cluster_issuer" {
  manifest = yamldecode(templatefile("${path.root}/../../modules/kubernetes/cert-manager/templates/cluster-issuer.tpl", {
    name        = "letsencrypt"
    issuerEmail = var.cert_issuer_email
  }))
}
