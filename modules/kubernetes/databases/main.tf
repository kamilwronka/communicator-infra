resource "helm_release" "users_database" {
  name       = "users-database"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = var.namespace
}

resource "helm_release" "mongodb" {
  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"

  timeout         = 180
  cleanup_on_fail = true
  force_update    = false
  namespace       = var.namespace
}
