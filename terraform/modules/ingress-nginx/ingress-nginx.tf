locals {
  # Ingress Nginx
  chart_name = "ingress-nginx"
  chart_repo = "https://kubernetes.github.io/ingress-nginx"

  labels = {
    "app.kubernetes.io/app"   = local.chart_name
    "app.kubernetes.io/owner" = var.owner
  }

  values = [
    yamlencode({
      controller = {
        service = {
          externalIPs = var.external_ips
        }
      }
    })
  ]
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
  timeout           = var.timeout
  values            = local.values
  version           = var.chart_version
  wait              = false
}