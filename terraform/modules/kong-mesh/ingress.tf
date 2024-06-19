resource "kubernetes_ingress_v1" "kong_mesh_ingress" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = kubernetes_namespace_v1.kong_mesh_ns.metadata[0].name
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
      host = var.domain_name
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "${local.app_name}-control-plane"
              port {
                number = 5681
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [var.domain_name]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
  }
  depends_on = [helm_release.kong_mesh]
}