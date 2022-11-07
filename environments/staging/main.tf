
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.15"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7.1"
    }
  }

  backend "s3" {
    bucket = "communicator-tf-state"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  config_path = var.kube_config_path
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

module "aws" {
  source = "../../modules/aws"

  project_name = var.project_name
  environment  = var.environment
  cors_origins = var.cors_origins
}

module "kubernetes_namespace" {
  source = "../../modules/kubernetes/namespace"

  environment  = var.environment
  project_name = var.project_name
}

module "kubernetes_secrets" {
  source = "../../modules/kubernetes/secrets"

  namespace = module.kubernetes_namespace.namespace

  environment                = var.environment
  project_name               = var.project_name
  aws_access_key_id          = var.aws_access_key_id
  aws_secret_access_key      = var.aws_secret_access_key
  jwt_auth_secret_key        = var.jwt_auth_secret_key
  jwt_auth_secret_public_key = var.jwt_auth_secret_public_key
  key_auth_key               = var.key_auth_key
  tls_secret_crt             = var.tls_secret_crt
  tls_secret_key             = var.tls_secret_key
  cdn_url                    = module.aws.cloudfront_url

  depends_on = [
    module.kubernetes_namespace,
    module.aws
  ]
}

module "kong_plugins" {
  source = "../../modules/kubernetes/kong-plugins"

  namespace    = module.kubernetes_namespace.namespace
  cors_origins = var.cors_origins

  depends_on = [
    module.kubernetes_namespace
  ]
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
