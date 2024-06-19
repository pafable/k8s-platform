locals {
  argo_domain         = "${local.app_name}.local"
  argo_server_service = "argocd-server"
  argo_server_port    = 443
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = kubernetes_namespace_v1.argocd_ns.metadata.0.name

    annotations = {
      "konghq.com/strip-path"                 = true
      "konghq.com/protocols"                  = "https"
      "konghq.com/https-redirect-status-code" = 301
    }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = "kong"
    rule {
      host = local.argo_domain
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = local.argo_server_service
              port {
                number = local.argo_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.argo_domain]
      secret_name = kubernetes_manifest.argocd_cert.manifest.spec.secretName
    }
  }
}