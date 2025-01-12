resource "kubernetes_ingress_v1" "prometheus_ingress" {
  metadata {
    name      = "prometheus-ingress"
    namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
    labels    = local.labels
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = var.ingress_name

    rule {
      host = local.prom_domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = "monitoring-kube-prometheus-prometheus"

              port {
                number = 9090
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.prom_domain]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
  }

  depends_on = [helm_release.kube_prom_stack]
}

resource "kubernetes_ingress_v1" "grafana_ingress" {
  metadata {
    name      = "grafana-ingress"
    namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
    labels    = local.labels
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = var.ingress_name

    rule {
      host = local.grafana_domain

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "monitoring-grafana"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.grafana_domain]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
  }

  depends_on = [helm_release.kube_prom_stack]
}

resource "kubernetes_ingress_v1" "loki_ingress" {
  metadata {
    name      = "loki-ingress"
    namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
    labels    = local.labels
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = var.ingress_name

    rule {
      host = local.loki_domain

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = local.loki_app_name

              port {
                number = 3100
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.loki_domain]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
  }

  depends_on = [helm_release.kube_prom_stack]
}