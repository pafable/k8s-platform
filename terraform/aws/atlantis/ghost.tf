resource "kubernetes_namespace_v1" "ghost_namespace" {
  metadata {
    name = local.ghost_app
  }
}

resource "kubernetes_pod_v1" "ghost" {
  metadata {
    name      = local.ghost_app
    namespace = local.ghost_app
    labels = {
      "app.kubernetes.io/name" = local.ghost_app
    }
  }

  spec {
    container {
      image = local.ghost_image
      name  = local.ghost_app

      env {
        name  = "NODE_ENV"
        value = "development"
      }

      port {
        container_port = local.ghost_port
      }
    }
  }
}

# service to expose the ghost application
resource "kubernetes_service_v1" "ghost_service" {
  metadata {
    name      = "${local.ghost_app}-svc"
    namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = local.ghost_app
    }

    port {
      port        = local.exposed_port
      target_port = kubernetes_pod_v1.ghost.spec.0.container.0.port.0.container_port
      protocol    = "TCP"
    }
  }
}