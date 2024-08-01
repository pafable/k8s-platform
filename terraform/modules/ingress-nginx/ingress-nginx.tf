locals {
  # Ingress Nginx
  chart_name = "ingress-nginx"
  chart_repo = "https://kubernetes.github.io/ingress-nginx"

  labels = {
    "kuma.io/sidecar-injection"    = "enabled"
    "app.kubernetes.io/app"        = local.chart_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "ingress_nginx_ns" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

# Ingress Nginx
resource "helm_release" "ingress_nginx_controller" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.chart_name
  namespace         = kubernetes_namespace_v1.ingress_nginx_ns.metadata[0].name
  repository        = local.chart_repo
  version           = var.chart_version
  timeout           = var.timeout
  wait              = false
}