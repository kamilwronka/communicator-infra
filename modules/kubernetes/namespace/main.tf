resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    labels = {
      environment     = var.environment
      istio-injection = "enabled"
    }

    name = "${var.project_name}-${var.environment}"
  }
}
