locals {
  domain       = "${local.app_name}.${var.domain}"
  port         = 8080
  service_name = local.app_name
}

resource "kubernetes_ingress_v1" "jenkins_ingress" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = kubernetes_namespace_v1.jenkins_ns.metadata.0.name
    labels    = local.labels
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = var.ingress_name

    rule {
      host = local.domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.service_name

              port {
                number = local.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.domain]
      secret_name = kubernetes_manifest.jenkins_cert.manifest.spec.secretName
    }
  }
}