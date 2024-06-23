resource "kubernetes_ingress_v1" "chaos_mesh_ingress" {
  metadata {
    name      = "chaos-mesh-ingress"
    namespace = kubernetes_namespace_v1.chaos_ns.metadata[0].name
    labels    = local.labels

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
      host = local.domain_name

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = "chaos-dashboard"

              port {
                number = 2333
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.domain_name]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
  }

  depends_on = [helm_release.chaos_mesh]
}