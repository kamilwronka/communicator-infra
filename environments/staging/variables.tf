variable "environment" {
  default = "staging"
}

variable "project_name" {
  default = "communicator"
}

variable "kube_config_path" {
  default = "~/.kube/config"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_access_key_id" {}

variable "aws_secret_access_key" {}

variable "jwt_auth_secret_key" {}

variable "jwt_auth_secret_public_key" {}

variable "key_auth_key" {}

variable "tls_secret_crt" {}

variable "tls_secret_key" {}

variable "cors_origins" {
  type = list(string)
}

variable "docker_config_json" {
  type = string
}
