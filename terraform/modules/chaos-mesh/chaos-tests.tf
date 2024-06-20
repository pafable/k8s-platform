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
        namespaces = [
          kubernetes_namespace_v1.chaos_ns.metadata.0.name
        ]
        labelSelectors = {
          app  = local.app_name
          tier = "frontend"
        }
      }
    }
  }
}