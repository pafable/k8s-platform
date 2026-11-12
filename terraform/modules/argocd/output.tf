data "kubernetes_resources" "exposed_gateway_svcs" {
  api_version    = "v1"
  kind           = "Service"
  namespace      = kubernetes_namespace_v1.argocd_ns.metadata.0.name
  label_selector = "gateway.networking.k8s.io/gateway-name=argocd-gateway"

  depends_on = [helm_release.argocd]
}

output "exposed_ip" {
  value      = data.kubernetes_resources.exposed_gateway_svcs.objects[0].status.loadBalancer.ingress[0].ip
  depends_on = [helm_release.argocd]
}