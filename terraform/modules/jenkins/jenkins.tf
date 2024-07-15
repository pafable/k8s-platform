locals {
  app_name    = "jenkins"
  chart_name  = local.app_name
  jenkins_url = "https://${local.app_name}.local"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      agent = {
        podName = "${local.app_name}-agent"
      }

      controller = {
        installPlugins = [
          "ansicolor:1.0.4",
          "blueocean:1.27.13",
          "configuration-as-code:1810.v9b_c30a_249a_4c",
          "docker-workflow:580.vc0c340686b_54",
          "git:5.2.2",
          "github:1.39.0",
          "kubernetes:4253.v7700d91739e5",
          "login-theme:146.v64a_da_cf70ea_6",
          "matrix-auth:3.2.2",
          "pipeline-build-step:540.vb_e8849e1a_b_d8",
          "pipeline-stage-view:2.34",
          "prometheus:773.v3b_62d8178eec",
          "rebuild:332.va_1ee476d8f6d",
          "workflow-aggregator:600.vb_57cdd26fdd7",
          "ws-cleanup:0.46",
        ]

        jenkinsUrl = local.jenkins_url
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "jenkins_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "jenkins" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.jenkins_ns.metadata.0.name
  repository        = var.helm_repo
  values            = local.values
  version           = var.helm_chart_version
}