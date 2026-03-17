data "kubernetes_resources" "exposed_gateway_svcs" {
  api_version    = "v1"
  kind           = "Service"
  namespace      = "envoy-gateway-system"
  label_selector = "app in (argocd)"

  depends_on = [helm_release.argocd]
}

output "exposed_ip" {
  value = data.kubernetes_resources.exposed_gateway_svcs.objects[0].status.loadBalancer.ingress[0].ip

  depends_on = [helm_release.argocd]
}