## Cert manager helm chart needs to be installed before creating the issuer
## Because the issuer is a CRD
## Comment out this line on initial deployment to new kubernetes clusters
## Then uncomment it after the first deployment
resource "kubernetes_manifest" "self_signed_cluster_issuer" {
  count = 1

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name   = "self-signed-ca-cluster-issuer"
      labels = local.labels
    }

    spec = {
      # you can only use one of these ClusterIssuer resource

      # ca allows you to use existing CA cert and CA private key
      ca = {
        secretName = kubernetes_secret_v1.ca_secret.metadata[0].name
      }

      ## allows cert manager to create the CA cert and CA private key automatically
      # self = {}
    }
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret_v1.ca_secret
  ]
}

resource "kubernetes_secret_v1" "ca_secret" {
  metadata {
    name      = "self-signed-ca-secret"
    namespace = kubernetes_namespace_v1.cert_manager_ns.metadata[0].name
  }

  data = {
    # DO NOT encode in base64.
    # these will automatically be encoded in base64.
    "tls.crt" = base64decode(var.ca_cert)
    "tls.key" = base64decode(var.ca_key)
  }

  type = "kubernetes.io/tls"
}