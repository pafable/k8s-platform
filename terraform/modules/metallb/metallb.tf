locals {
  app_name   = "metallb"
  repo       = "https://metallb.github.io/metallb"
  chart_name = local.app_name

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "metallb_ns" {
  metadata {
    name = "${local.app_name}-system"
    # labels = local.labels
  }
}

resource "helm_release" "metallb" {
  chart            = local.chart_name
  create_namespace = false
  force_update     = true
  timeout          = 180
  name             = local.app_name
  namespace        = kubernetes_namespace_v1.metallb_ns.metadata[0].name
  repository       = local.repo
  version          = var.metallb_version

  depends_on = [kubernetes_namespace_v1.metallb_ns]
}