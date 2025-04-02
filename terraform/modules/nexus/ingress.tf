locals {
  nexus_domain      = "${local.app_name}.${var.domain}"
  nexus_server_svc  = "${local.app_name}-ui"
  nexus_server_port = 8081
}

resource "kubernetes_ingress_v1" "vault_ingress" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = kubernetes_namespace_v1.nexus_ns.metadata.0.name
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
      host = local.nexus_domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.nexus_server_svc

              port {
                number = local.nexus_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.nexus_domain]
      secret_name = kubernetes_manifest.vault_cert.manifest.spec.secretName
    }
  }
}