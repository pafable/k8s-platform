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
        configAnnotations = {
          ssl-ciphers   = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA"
          ssl-protocols = "TLSv1.2 TLSv1.3"
        }

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