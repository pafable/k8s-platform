resource "aws_ssm_parameter" "jellyfin_ip" {
  provider  = aws.parameters
  name      = "/apps/jellyfin/service/ip"
  type      = "String"
  value     = module.jellyfin.exposed_ip
  overwrite = true

  depends_on = [module.jellyfin]
}

resource "aws_ssm_parameter" "grafana_ip" {
  provider  = aws.parameters
  name      = "/apps/grafana/service/ip"
  type      = "String"
  value     = module.kube_prom.exposed_grafana_ip
  overwrite = true

  depends_on = [module.kube_prom]
}

resource "aws_ssm_parameter" "prometheus_ip" {
  provider  = aws.parameters
  name      = "/apps/prometheus/service/ip"
  type      = "String"
  value     = module.kube_prom.exposed_prometheus_ip
  overwrite = true

  depends_on = [module.kube_prom]
}