locals {
  app_name   = "podinfo"
  chart_name = local.app_name
  helm_repo  = "oci://ghcr.io/stefanprodan/charts"

  tf_labels = {
    app                            = local.app_name
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  podinfo_domain         = "${local.app_name}.${var.domain}"
  podinfo_server_service = local.app_name
  podinfo_server_port    = 9898

  values = [
    yamlencode({
      replicaCount = var.replicas
    })
  ]
}

resource "kubernetes_namespace_v1" "podinfo_ns" {
  metadata {
    name   = local.app_name
    labels = local.tf_labels
  }
}

resource "helm_release" "podinfo" {
  chart             = local.chart_name
  cleanup_on_fail   = true
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.podinfo_ns.metadata.0.name
  repository        = local.helm_repo
  values            = local.values
  version           = var.chart_version
}