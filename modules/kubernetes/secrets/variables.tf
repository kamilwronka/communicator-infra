variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "jwt_auth_secret_key" {
  type = string
}

variable "jwt_auth_secret_public_key" {
  type = string
}

variable "key_auth_key" {
  type = string
}

variable "tls_secret_crt" {
  type = string
}

variable "tls_secret_key" {
  type = string
}

variable "cdn_url" {
  type = string
}
