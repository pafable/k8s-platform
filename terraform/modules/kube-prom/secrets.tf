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

resource "kubernetes_secret_v1" "prometheus_ui_secret" {
  metadata {
    name      = "prometheus-ui-auth"
    namespace = kubernetes_namespace_v1.kube_prom_ns.metadata[0].name
  }

  data = {
    ".htpasswd" = file("${path.module}/.htpasswd")
  }

  type = "Opaque"
}