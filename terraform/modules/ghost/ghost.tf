locals {
  app_name            = "ghost"
  domain_name         = "ghost.local"
  exposed_port        = 80
  owner               = "devops"
  self_signed_ca_name = "self-signed-cluster-ca-issuer"

  # Ghost params
  ghost_app   = "ghost"
  ghost_image = "ghost:5.82.2"
  ghost_port  = 2368
}

resource "kubernetes_namespace_v1" "ghost_namespace" {
  metadata {
    name = local.ghost_app

    labels = {
      # adds any pods and services deployed to this namespace to the kong/kuma mesh
      "kuma.io/sidecar-injection"    = "enabled"
      "kuma.io/sidecar-injection"    = "enabled"
      "app.kubernetes.io/app"        = local.app_name
      "app.kubernetes.io/managed-by" = "Terraform"
      "app.kubernetes.io/owner"      = local.owner
    }
  }
}

resource "kubernetes_deployment_v1" "ghost_deployment" {
  metadata {
    name      = local.ghost_app
    namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
    annotations = {
      "kuma.io/gateway" = "enabled"
    }
    labels = {
      "app.kubernetes.io/name" = local.ghost_app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.ghost_app
      }
    }

    template {
      metadata {
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
    name      = "${local.ghost_app}-svc"
    namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
    annotations = {
      "ingress.kubernetes.io/service-upstream" = true
    }
    labels = {
      "app.kubernetes.io/name" = local.ghost_app
      jobLabel                 = local.ghost_app
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = local.ghost_app
    }

    port {
      name        = local.ghost_app
      port        = local.exposed_port
      target_port = kubernetes_deployment_v1.ghost_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
      protocol    = "TCP"
    }
  }
}