resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = var.namespace
}
