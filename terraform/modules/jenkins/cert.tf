locals {
  issuer = "self-signed-ca-cluster-issuer"
}

resource "kubernetes_manifest" "jenkins_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.app_name}-cert"
      namespace = kubernetes_namespace_v1.jenkins_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.labels
    }

    spec = {
      commonName = local.domain

      dnsNames = [
        local.domain
      ]

      isCA = false

      issuerRef = {
        name = local.issuer
        kind = "ClusterIssuer"
      }

      privateKey = {
        algorithm = "ECDSA"
        encoding  = "PKCS1"
        size      = 521
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

  depends_on = [helm_release.jenkins]
}