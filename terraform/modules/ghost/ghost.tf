locals {
  domain_name         = "ghost.pafable.com"
  exposed_port        = 80
  owner               = "devops"
  self_signed_ca_name = "self-signed-cluster-ca-issuer"

  # Ghost params
  ghost_app   = "ghost"
  ghost_image = "ghost:6.10.3"
  ghost_port  = 2368

  labels = {
    "kuma.io/sidecar-injection"    = "enabled" # adds any pods and services deployed to this namespace to the kong/kuma mesh
    "app.kubernetes.io/name"       = var.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = local.owner
    jobLabel                       = local.ghost_app
  }

  app_labels = merge(local.labels, var.app_version)
}

resource "kubernetes_namespace_v1" "ghost_namespace" {
  metadata {
    name   = var.namespace
    labels = local.app_labels
  }
}

resource "kubernetes_deployment_v1" "ghost_deployment" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
    labels    = local.app_labels

    annotations = {
      "kuma.io/gateway" = "enabled"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.ghost_app
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 3
        max_unavailable = 1
      }
    }

    template {
      metadata {
        labels = merge(
          { "app.kubernetes.io/name" = local.ghost_app },
          var.app_version
        )
      }

      spec {
        container {
          image = local.ghost_image
          name  = var.app_name

          env {
            name  = "NODE_ENV"
            value = "development"
          }

          port {
            name           = local.ghost_app
            container_port = local.ghost_port
          }
        }
      }
    }
  }
}

# service to expose the ghost application
resource "kubernetes_service_v1" "ghost_service" {
  metadata {
    name      = "${var.app_name}-svc"
    namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
    labels    = local.app_labels

    # annotations = {
    #   "ingress.kubernetes.io/service-upstream" = true
    # }
  }

  spec {
    selector = merge(
      { "app.kubernetes.io/name" = local.ghost_app },
      var.app_version
    )

    type         = "LoadBalancer"
    external_ips = var.controller_ips

    port {
      name        = local.ghost_app
      port        = local.exposed_port
      target_port = kubernetes_deployment_v1.ghost_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
      protocol    = "TCP"
    }
  }

  timeouts {
    create = "3m"
    update = "3m"
    delete = "3m"
  }
}