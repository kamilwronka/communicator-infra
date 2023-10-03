variable "environment" {
  default = "dev"
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

variable "cors_origins" {
  type        = list(string)
  description = "list of allowed cors origins"
}

variable "cdn_url" {
  type        = string
  description = "aws cdn url"
}
