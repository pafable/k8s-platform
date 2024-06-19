# ingress to expose the atlantis application
# this needs an ingress controller to be installed
# I am using the nginx ingress controller (see kube-support/helm.tf)
resource "kubernetes_ingress_v1" "atlantis_ingress" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = kubernetes_namespace_v1.atlantis_namespace.id
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/$1" # /$1 is needed to display images properly
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = true
    }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = "nginx"
    rule {
      host = var.atlantis_domain
      http {
        path {
          path = "/?(.*)" # /?(.*) is needed to display images properly
          backend {
            service {
              name = kubernetes_service_v1.atlantis.metadata[0].name
              port {
                number = kubernetes_service_v1.atlantis.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    # configures tls certificate for atlantis.YOUR-DOMAIN.com
    tls {
      hosts       = [var.atlantis_domain]
      secret_name = kubernetes_secret_v1.atlantis_tls_secret.metadata[0].name
    }
  }
}

# ghost ingress
resource "kubernetes_ingress_v1" "ghost_ingress" {
  metadata {
    name      = "${local.ghost_app}-ingress"
    namespace = kubernetes_namespace_v1.ghost_namespace.id
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/$1" # /$1 is needed to display images properly
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = true
    }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = "nginx"
    rule {
      host = var.ghost_domain
      http {
        path {
          path = "/?(.*)" # /?(.*) is needed to display images properly
          backend {
            service {
              name = kubernetes_service_v1.ghost_service.metadata[0].name
              port {
                number = kubernetes_service_v1.ghost_service.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}