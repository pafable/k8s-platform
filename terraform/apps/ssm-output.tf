module "output_ssm" {
  source = "../modules/ssm-writer"

  parameters = [
    {
      description = "Jellyfin Loadbalancer IP"
      name        = "/apps/jellyfin/loadbalancer/ip"
      value       = module.jellyfin.exposed_ip
    },
    {
      description = "Grafana Loadbalancer IP"
      name        = "/apps/grafana/loadbalancer/ip"
      value       = module.kube_prom.exposed_grafana_ip
    },
    {
      description = "Prometheus Loadbalancer IP"
      name        = "/apps/prometheus/loadbalancer/ip"
      value       = module.kube_prom.exposed_prometheus_ip
    },
    {
      description = "ArgoCD Loadbalancer IP"
      name        = "/apps/argocd/loadbalancer/ip"
      value       = module.argocd.exposed_ip
    }
  ]

  depends_on = [
    module.argocd,
    module.jellyfin,
    module.kube_prom
  ]
}