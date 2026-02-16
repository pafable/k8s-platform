data "kubernetes_resources" "exposed_gateway_grafana_svc" {
  api_version    = "v1"
  kind           = "Service"
  namespace      = "envoy-gateway-system"
  label_selector = "app in (grafana)"

  depends_on = [helm_release.kube_prom_stack]
}

output "exposed_grafana_ip" {
  value = data.kubernetes_resources.exposed_gateway_grafana_svc.objects[0].status.loadBalancer.ingress[0].ip
}

data "kubernetes_resources" "exposed_gateway_prometheus_svc" {
  api_version    = "v1"
  kind           = "Service"
  namespace      = "envoy-gateway-system"
  label_selector = "app in (prometheus)"

  depends_on = [helm_release.kube_prom_stack]
}

output "exposed_prometheus_ip" {
  value = data.kubernetes_resources.exposed_gateway_prometheus_svc.objects[0].status.loadBalancer.ingress[0].ip
}