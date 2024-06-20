locals {
  target_namespace = "argo-example-app"
  target_app_name  = "myhelmapp"
  target_app_tier  = "frontend"
}

resource "kubernetes_manifest" "pod_killer" {
  manifest = {
    apiVersion = "chaos-mesh.org/v1alpha1"
    kind       = "PodChaos"

    metadata = {
      name      = "${local.app_name}-pod-killer"
      namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name
      labels = {
        app   = local.app_name
        owner = var.owner
      }
    }

    spec = {
      action = "pod-kill"
      mode   = "all"

      selector = {
        namespaces = [local.target_namespace]
        labelSelectors = {
          app  = local.target_app_name
          tier = local.target_app_tier
        }
      }
    }
  }
}