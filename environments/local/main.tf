
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

  backend "local" {
    path = "./terraform.tfstate"
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

module "kubernetes_namespace" {
  source = "../../modules/kubernetes/namespace"

  environment  = var.environment
  project_name = var.project_name
}

resource "kubernetes_secret_v1" "aws_secrets" {
  metadata {
    name      = "aws"
    namespace = module.kubernetes_namespace.namespace
  }

  data = {
    aws-access-key-id     = var.aws_access_key_id
    aws-secret-access-key = var.aws_secret_access_key
    aws-s3-bucket-name    = "${var.project_name}-${var.environment}"
  }
}

resource "kubernetes_secret_v1" "cdn_secrets" {
  metadata {
    name      = "cdn"
    namespace = module.kubernetes_namespace.namespace
  }

  data = {
    cdnUrl : var.cdn_url
  }
}

resource "kubernetes_manifest" "kong_cors_plugin" {
  manifest = yamldecode(templatefile("${path.root}/../../modules/kubernetes/kong-plugins/templates/kong-cors-plugin.tpl", {
    namespace    = module.kubernetes_namespace.namespace
    cors_origins = var.cors_origins
  }))
}

module "databases" {
  source = "../../modules/kubernetes/databases"

  namespace = module.kubernetes_namespace.namespace

  depends_on = [
    module.kubernetes_namespace
  ]
}

module "message_brokers" {
  source = "../../modules/kubernetes/message-brokers"

  namespace = module.kubernetes_namespace.namespace

  depends_on = [
    module.kubernetes_namespace
  ]
}
