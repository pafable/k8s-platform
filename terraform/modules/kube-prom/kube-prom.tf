locals {
  enable_node_exporter = var.is_talos ? false : true

  labels = {
    "app.kubernetes.io/app"        = var.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "kube_prom_ns" {
  metadata {
    name   = "monitoring"
    labels = local.labels
  }
}

resource "helm_release" "kube_prom_stack" {
  chart             = var.app_name
  cleanup_on_fail   = true
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = var.app_name
  namespace         = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
  repository        = var.chart_repo
  values            = local.values
  version           = var.chart_version
}

resource "random_password" "grafana_admin_password" {
  length = 30
}

resource "kubernetes_secret_v1" "grafana_admin_creds" {
  metadata {
    name      = "grafana-admin-creds"
    namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
    labels    = local.labels
  }

  data = {
    username = "${var.owner}-admin"
    password = sensitive(random_password.grafana_admin_password.result)
  }
}