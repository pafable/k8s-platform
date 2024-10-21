locals {
  kibana_name         = "kibana"
  kibana_domain       = "${local.kibana_name}.local"
  kibana_port         = 5601
  kibana_service_name = "elastic-stack-eck-kibana-kb-http"
}

resource "kubernetes_ingress_v1" "kibana_ingress" {
  metadata {
    name      = "${local.kibana_name}-ingress"
    namespace = kubernetes_namespace_v1.eck_op_ns.metadata.0.name
    labels    = local.labels

    annotations = {
      "konghq.com/strip-path"                 = true
      "konghq.com/protocols"                  = "https"
      "konghq.com/https-redirect-status-code" = 301
    }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = "ingress-nginx"

    rule {
      host = local.kibana_domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.kibana_service_name

              port {
                number = local.kibana_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.kibana_domain]
      secret_name = kubernetes_manifest.kibana_cert.manifest.spec.secretName
    }
  }
}