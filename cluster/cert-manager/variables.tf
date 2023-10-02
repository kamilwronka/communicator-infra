variable "kube_config_path" {
  default     = "~/.kube/config"
  description = "path to the kube config file"
}

variable "cert_issuer_email" {
  description = "value of the email field in the cluster issuer"
  type        = string
  sensitive   = true
}
