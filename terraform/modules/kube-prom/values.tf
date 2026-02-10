locals {
  node_exporter_config = {
    nodeExporter = {
      enabled = local.enable_node_exporter # this must be set to false for talos
    }
  }

  grafana_config = {
    grafana = {
      admin = {
        existingSecret = kubernetes_secret_v1.grafana_admin_creds.metadata.0.name
        userKey        = "username"
        passwordKey    = "password"
      }
      assertNoLeakedSecrets = false # this is needed for custom creds
    }
  }

  values = [
    yamlencode(
      merge(
        local.node_exporter_config,
        local.grafana_config
      )
    )
  ]
}