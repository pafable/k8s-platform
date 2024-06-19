resource "kubernetes_deployment_v1" "atlantis" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace_v1.atlantis_namespace.id
    labels = {
      "app.kubernetes.io/name" = local.app_name
    }
  }

  spec {
    replicas = local.replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.app_name
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.app_name
        }
      }

      spec {
        container {
          name  = local.app_name
          image = local.container_image

          env {
            name  = "ATLANTIS_ATLANTIS_URL"
            value = "https://${var.atlantis_domain}" # change this to ngrok url if testing locally
          }

          env {
            name  = "ATLANTIS_DEFAULT_TF_VERSION"
            value = local.terraform_version
          }

          env {
            name  = "ATLANTIS_REPO_ALLOWLIST"
            value = var.repo_allowlist
          }

          env {
            name = "ATLANTIS_GH_USER"
            value_from {
              secret_key_ref {
                name = "github-token"
                key  = "user"
              }
            }
          }

          env {
            name = "ATLANTIS_GH_TOKEN"
            value_from {
              secret_key_ref {
                name = "github-token"
                key  = "token"
              }
            }
          }

          env {
            name = "ATLANTIS_GH_WEBHOOK_SECRET"
            value_from {
              secret_key_ref {
                name = "github-webhook-secret"
                key  = "secret"
              }
            }
          }

          env {
            name  = "ATLANTIS_PORT"
            value = local.atlantis_port
          }

          port {
            name           = local.app_name
            container_port = local.atlantis_port
          }

          resources {
            limits = {
              cpu    = local.resource_cpu
              memory = local.resource_memory
            }
            requests = {
              cpu    = local.resource_cpu
              memory = local.resource_memory
            }
          }

          liveness_probe {
            period_seconds = local.period
            http_get {
              path   = local.path
              port   = local.atlantis_port
              scheme = local.scheme
            }
          }

          readiness_probe {
            period_seconds = local.period
            http_get {
              path   = local.path
              port   = local.atlantis_port
              scheme = local.scheme
            }
          }
        }
      }
    }
  }
}

# service to expose the atlantis application
resource "kubernetes_service_v1" "atlantis" {
  metadata {
    name      = "${local.app_name}-svc"
    namespace = kubernetes_namespace_v1.atlantis_namespace.id
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = local.app_name
    }

    port {
      port        = local.exposed_port
      target_port = local.atlantis_port
      protocol    = "TCP"
    }
  }
}