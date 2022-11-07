resource "kubernetes_manifest" "kong_cors_plugin" {
  manifest = yamldecode(templatefile("${path.module}/templates/kong-cors-plugin.tpl", {
    namespace    = var.namespace
    cors_origins = var.cors_origins
  }))
}

resource "kubernetes_manifest" "kong_jwt_plugin" {
  manifest = yamldecode(templatefile("${path.module}/templates/kong-jwt-plugin.tpl", {
    namespace = var.namespace
  }))
}

resource "kubernetes_manifest" "kong_keyauth_plugin" {
  manifest = yamldecode(templatefile("${path.module}/templates/kong-keyauth-plugin.tpl", {
    namespace = var.namespace
  }))
}

resource "kubernetes_manifest" "kong_keyauth_consumer" {
  manifest = yamldecode(templatefile("${path.module}/templates/kong-keyauth-consumer.tpl", {
    namespace = var.namespace
  }))
}

resource "kubernetes_manifest" "kong_jwtauth_consumer" {
  manifest = yamldecode(templatefile("${path.module}/templates/kong-jwt-consumer.tpl", {
    namespace = var.namespace
  }))
}
