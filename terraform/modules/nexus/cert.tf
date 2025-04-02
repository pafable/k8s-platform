locals {
  issuer = "self-signed-ca-cluster-issuer"
}

resource "kubernetes_manifest" "vault_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.app_name}-cert"
      namespace = kubernetes_namespace_v1.nexus_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.tf_labels
    }

    spec = {
      commonName = local.nexus_domain

      dnsNames = [
        local.nexus_domain
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
  depends_on = [helm_release.vault]
}