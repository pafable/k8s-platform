locals {
  issuer = "self-signed-ca-cluster-issuer"
}

resource "kubernetes_manifest" "argocd_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.app_name}-cert"
      namespace = kubernetes_namespace_v1.argocd_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.tf_labels
    }

    spec = {
      commonName = local.argo_domain

      dnsNames = [
        local.argo_domain
      ]

      isCA = true

      issuerRef = {
        name = local.issuer
        kind = "ClusterIssuer"
      }

      privateKey = {
        algorithm = "ECDSA"
        encoding  = "PKCS1"
        size      = 256
      }

      secretName = "${local.app_name}-tls"

      subject = {
        organizations = [
          var.owner
        ]
        organizationalUnits = [
          var.ou
        ]
      }
    }
  }
  depends_on = [helm_release.argodcd]
}