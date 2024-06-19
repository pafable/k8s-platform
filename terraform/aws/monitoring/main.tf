locals {
  cluster_name       = "xyz"
  kube_namespace     = "default"
  kube_chart_name    = "kube-prometheus-stack"
  kube_chart_repo    = "https://prometheus-community.github.io/helm-charts"
  kube_chart_version = "57.1.1"
  kube_name          = "monitoring"
}

resource "helm_release" "kube_prom_stack" {
  chart      = local.kube_chart_name
  name       = local.kube_name
  namespace  = local.kube_namespace
  repository = local.kube_chart_repo
  version    = local.kube_chart_version

  #   values = [
  #     yamlencode({
  #       # This needs to be set to false if deploying on docker-desktop cluster on windows
  #       prometheus-node-exporter = {
  #         hostRootFsMount = {
  #           enabled = false
  #         }
  #       }
  #     })
  #   ]
}