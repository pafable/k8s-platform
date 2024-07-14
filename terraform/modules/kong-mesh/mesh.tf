locals {
  app_name            = "kong-mesh"
  repository          = "https://kong.github.io/kong-mesh-charts"
  self_signed_ca_name = "self-signed-cluster-ca-issuer"

  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      kuma = {
        controlPlane = {
          defaults = {
            skipMeshCreation = true
          }
        }
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "kong_mesh_ns" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "helm_release" "kong_mesh" {
  chart             = local.app_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.kong_mesh_ns.metadata[0].name
  repository        = local.repository
  values            = local.values
  version           = var.chart_version
}