resource "kubernetes_secret_v1" "aws_secrets" {
  metadata {
    name      = "aws"
    namespace = var.namespace
  }

  data = {
    aws-access-key-id     = var.aws_access_key_id
    aws-secret-access-key = var.aws_secret_access_key
    aws-s3-bucket-name    = "${var.project_name}-${var.environment}"
  }
}

resource "kubernetes_secret_v1" "jwt_auth_secrets" {
  metadata {
    name      = "jwt-auth"
    namespace = var.namespace
  }

  data = {
    algorithm      = "RS256"
    key            = var.jwt_auth_secret_key
    kongCredType   = "jwt"
    rsa_public_key = var.jwt_auth_secret_public_key
  }
}

resource "kubernetes_secret_v1" "key_auth_secrets" {
  metadata {
    name      = "key-auth"
    namespace = var.namespace
  }

  data = {
    key          = var.key_auth_key
    kongCredType = "key-auth"
  }
}

resource "kubernetes_secret_v1" "tls_secrets" {
  metadata {
    name      = "tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = var.tls_secret_crt
    "tls.key" = var.tls_secret_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret_v1" "cdn_secrets" {
  metadata {
    name      = "cdn"
    namespace = var.namespace
  }

  data = {
    cdnUrl : var.cdn_url
  }
}

resource "kubernetes_secret_v1" "docker_registry" {
  metadata {
    name      = "docker-registry"
    namespace = var.namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = var.docker_config_json
  }
}

resource "kubernetes_default_service_account" "default" {
  metadata {
    name = "${var.namespace}-default"
  }
  image_pull_secret {
    name = "docker-registry"
  }
}
