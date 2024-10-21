locals {
  vault_domain         = "${local.app_name}.${var.domain}"
  vault_server_service = "${local.app_name}-ui"
  vault_server_port    = 8200
}

resource "kubernetes_ingress_v1" "vault_ingress" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = kubernetes_namespace_v1.vault_ns.metadata.0.name
    labels    = local.tf_labels

    annotations = {
      "konghq.com/strip-path"                 = true
      "konghq.com/protocols"                  = "https"
      "konghq.com/https-redirect-status-code" = 301
    }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = var.ingress_name

    rule {
      host = local.vault_domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.vault_server_service

              port {
                number = local.vault_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.vault_domain]
      secret_name = kubernetes_manifest.vault_cert.manifest.spec.secretName
    }
  }
}