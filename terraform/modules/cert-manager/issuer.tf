## Cert manager helm chart needs to be installed before creating the issuer
## Because the issuer is a CRD
## Comment out this line on initial deployment to new kubernetes clusters
## Then uncomment it after the first deployment
resource "kubernetes_manifest" "self_signed_cluster_issuer" {
  count = local.install_count
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name   = "self-signed-cluster-ca-issuer"
      labels = local.labels
    }
    spec = {
      selfSigned = {}
    }
  }
  depends_on = [helm_release.cert_manager]
}