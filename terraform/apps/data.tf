locals {
  gateway_namespace = "envoy-gateway-system"
  apps              = "(jellyfin, grafana, prometheus)"
}

data "kubernetes_resources" "exposed_gateway_svcs" {
  api_version    = "v1"
  kind           = "Service"
  namespace      = local.gateway_namespace
  label_selector = "app in ${local.apps}"
}

# TODO: Create A records for these IPs in DNS
output "jellyfin_exposed_ips" {
  value = data.kubernetes_resources.exposed_gateway_svcs.objects[0].status.loadBalancer.ingress[0].ip
}

output "grafana_exposed_ips" {
  value = data.kubernetes_resources.exposed_gateway_svcs.objects[1].status.loadBalancer.ingress[1].ip
}

output "prometheus_exposed_ips" {
  value = data.kubernetes_resources.exposed_gateway_svcs.objects[2].status.loadBalancer.ingress[1].ip
}