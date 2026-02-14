data "kubernetes_resources" "exposed_gateway_svcs" {
  api_version    = "v1"
  kind           = "Service"
  namespace      = "envoy-gateway-system"
  label_selector = "app=jellyfin"

  depends_on = [kubernetes_service_v1.jellyfin_service]
}

output "exposed_ip" {
  value = data.kubernetes_resources.exposed_gateway_svcs.objects[0].status.loadBalancer.ingress[0].ip
}
