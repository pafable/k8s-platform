locals {
  labels = {
    "app.kubernetes.io/app"        = var.namespace
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
    app                            = var.namespace
  }
}

resource "kubernetes_namespace_v1" "jellyfin_ns" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "kubernetes_deployment_v1" "jellyfin_deployment" {
  metadata {
    name      = "${local.labels.app}-server"
    namespace = kubernetes_namespace_v1.jellyfin_ns.metadata[0].name
    labels    = local.labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        name   = "${local.labels.app}-server"
        labels = local.labels
      }

      spec {
        container {
          name              = local.labels.app
          image             = var.container_image
          image_pull_policy = "IfNotPresent"

          resources {
            requests = {
              cpu    = "100m"
              memory = "0.3Gi"
            }
          }

          port {
            container_port = 80
            name           = local.labels.app
            protocol       = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "jellyfin_service" {
  metadata {
    name      = "${local.labels.app}-svc"
    namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name
    labels    = local.labels
  }

  spec {
    selector = merge(
      { "app.kubernetes.io/name" = local.labels.app },
      var.app_version
    )

    type         = "LoadBalancer"
    external_ips = var.controller_ips

    port {
      name        = local.labels.app
      port        = 80
      target_port = kubernetes_deployment_v1.jellyfin_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
      protocol    = "TCP"
    }
  }

  timeouts {
    create = "3m"
  }
}