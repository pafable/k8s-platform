resource "kubernetes_manifest" "self_signed_cluster_issuer" {
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
}

resource "kubernetes_secret_v1" "ca_secret" {
  metadata {
    name      = "self-signed-ca-secret"
    namespace = "cert-manager"
  }

  data = {
    # DO NOT encode in base64.
    # these will automatically be encoded in base64.
    "tls.crt" = base64decode(data.aws_ssm_parameter.ca_cert.value)
    "tls.key" = base64decode(data.aws_ssm_parameter.ca_private_key.value)
  }

  type = "kubernetes.io/tls"
}