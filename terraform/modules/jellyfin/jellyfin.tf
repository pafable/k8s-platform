locals {
  labels = merge(
    {
      "app.kubernetes.io/app"        = var.namespace
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/owner"      = var.owner
      app                            = var.namespace
    },
    var.app_version
  )
}

resource "kubernetes_namespace_v1" "jellyfin_ns" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "kubernetes_deployment_v1" "jellyfin_deployment" {
  metadata {
    name      = "${var.namespace}-server"
    namespace = kubernetes_namespace_v1.jellyfin_ns.metadata[0].name
    labels    = local.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        name   = "${var.namespace}-server"
        labels = local.labels
      }

      spec {
        container {
          name              = var.namespace
          image             = var.container_image
          image_pull_policy = "IfNotPresent"

          resources {
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }
          }

          port {
            container_port = 8096
            name           = var.namespace
            protocol       = "TCP"
          }

          volume_mount {
            mount_path = "/${local.nfs_volumes[0]}"
            name       = local.nfs_volumes[0]
          }

          volume_mount {
            mount_path = "/${local.nfs_volumes[1]}"
            name       = local.nfs_volumes[1]
          }

          volume_mount {
            mount_path = "/${local.nfs_volumes[2]}"
            name       = local.nfs_volumes[2]
          }
        }

        node_name = var.node_name

        volume {
          name = local.nfs_volumes[0]
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.jellyfin_pvc["cache"].metadata[0].name
          }
        }

        volume {
          name = local.nfs_volumes[1]
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.jellyfin_pvc["config"].metadata[0].name
          }
        }

        volume {
          name = local.nfs_volumes[2]
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.jellyfin_pvc["media"].metadata[0].name
          }
        }
      }
    }
  }

  timeouts {
    create = "2m"
  }
}

resource "kubernetes_service_v1" "jellyfin_service" {
  metadata {
    name      = "${var.namespace}-svc"
    namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name
    labels    = kubernetes_deployment_v1.jellyfin_deployment.spec[0].template[0].metadata[0].labels
  }

  spec {
    selector     = local.labels
    type         = "ClusterIP"
    external_ips = var.controller_ips

    port {
      name        = var.namespace
      port        = 80
      target_port = kubernetes_deployment_v1.jellyfin_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
      protocol    = "TCP"
    }
  }

  timeouts {
    create = "2m"
  }

  depends_on = [kubernetes_deployment_v1.jellyfin_deployment]
}