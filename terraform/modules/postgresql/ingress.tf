locals {
  pgadmin_domain = "${local.pg_name}.${var.domain}"
}

resource "kubernetes_ingress_v1" "pgadmin_ingress" {
  metadata {
    name      = "${local.pg_name}-ingress"
    namespace = kubernetes_namespace_v1.postgresql_ns.metadata.0.name
    labels    = local.labels

    # annotations = {
    #   "konghq.com/strip-path"                 = true
    #   "konghq.com/protocols"                  = "https"
    #   "konghq.com/https-redirect-status-code" = 301
    # }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = var.ingress_name

    rule {
      host = local.pgadmin_domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = kubernetes_service_v1.pgadmin_service.metadata[0].name

              port {
                number = kubernetes_service_v1.pgadmin_service.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.pgadmin_domain]
      secret_name = kubernetes_manifest.pgadmin_cert.manifest.spec.secretName
    }
  }
}