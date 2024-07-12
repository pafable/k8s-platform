locals {
  kube_chart_name     = "kube-prometheus-stack"
  kube_chart_repo     = "https://prometheus-community.github.io/helm-charts"
  kube_name           = "monitoring"
  enable_grafana_db   = false # this is needed for data persistence in grafana
  grafana_db_name     = local.enable_grafana_db ? "postgres" : null
  grafana_db_host     = local.enable_grafana_db ? "REPLACE_WITH_YOUR_DB_HOST" : null
  grafana_db_password = local.enable_grafana_db ? "REPLACE_WITH_YOUR_PW" : null
  grafana_db_type     = local.enable_grafana_db ? "postgres" : null
  grafana_db_user     = local.enable_grafana_db ? "REPLACE_WITH_YOUR_DB_USER" : null
  grafana_domain      = "grafana.local"
  prom_domain         = "prometheus.local"
  self_signed_ca_name = "self-signed-cluster-ca-issuer"

  labels = {
    "app.kubernetes.io/app"        = local.kube_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  local_host_root = var.is_cloud ? null : {
    # This needs to be set to false if deploying on docker-desktop cluster on windows
    prometheus-node-exporter = {
      hostRootFsMount = {
        enabled = false
      }
    }
  }

  global_configs = {
    commonLabels = {
      "app.kubernetes.io/owner" = var.owner
    }
  }

  grafana_admin_pw = sensitive(random_password.grafana_admin_password.result)

  grafana_configs = {
    grafana = {
      assertNoLeakedSecrets = false
      admin = {
        existingSecret = kubernetes_secret_v1.grafana_admin_creds.metadata.0.name
        userKey        = "username"
        passwordKey    = "password"
      }

      additionalDataSources = [
        {
          name      = "aws-test"
          type      = "cloudwatch"
          access    = "proxy"
          isDefault = false

          jsonData = {
            authType      = "arn"
            defaultRegion = "us-east-1"
          }
        },
        {
          name      = "chaos-mesh"
          type      = "chaosmeshorg-datasource"
          url       = "https://chaos.local/"
          access    = "proxy"
          isDefault = false

          jsonData = {
            tlsSkipVerify = true
          }
        }
      ]

      "grafana.ini" = {
        database = {
          type     = local.grafana_db_type
          host     = local.grafana_db_host
          name     = local.grafana_db_name
          user     = local.grafana_db_user
          password = local.grafana_db_password
        }

        log = {
          level = "debug"
        }

        server = {
          domain   = local.grafana_domain
          root_url = "https://${local.grafana_domain}"
        }
      }

      image = {
        repository = var.grafana_image_repo
        tag        = var.grafana_image_tag
      }

      plugins = [
        "chaosmeshorg-datasource",
        "grafana-clock-panel",
        "grafana-oncall-app",
        "grafana-piechart-panel",
        "grafana-worldmap-panel",
        "digrich-bubblechart-panel"
      ]
    }
  }
}

resource "helm_release" "kube_prom_stack" {
  chart            = local.kube_chart_name
  create_namespace = false
  force_update     = true
  name             = var.app_name
  namespace        = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
  repository       = local.kube_chart_repo
  version          = var.chart_version

  values = [
    yamlencode(
      merge(
        local.global_configs,
        local.grafana_configs,
        local.local_host_root
      )
    )
  ]
}

resource "kubernetes_namespace_v1" "kube_prom_ns" {
  metadata {
    name   = local.kube_name
    labels = local.labels
  }
}

resource "random_password" "grafana_admin_password" {
  length = 25
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