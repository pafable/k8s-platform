locals {
  # Ingress Nginx
  chart_name = "ingress-nginx"
  chart_repo = "https://kubernetes.github.io/ingress-nginx"
}

# Ingress Nginx
resource "helm_release" "ingress_nginx_controller" {
  chart            = local.chart_name
  create_namespace = true
  name             = local.chart_name
  namespace        = var.namespace
  repository       = local.chart_repo
  version          = var.chart_version
}