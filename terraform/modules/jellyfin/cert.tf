resource "kubernetes_manifest" "cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${var.namespace}-cert"
      namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name
      labels    = local.labels
    }

    spec = {
      commonName = var.domain

      dnsNames = [
        var.domain
      ]

      isCA = true

      issuerRef = {
        name = var.self_signed_ca_name
        kind = "ClusterIssuer"
      }

      privateKey = {
        algorithm = "ECDSA"
        encoding  = "PKCS1"
        size      = 256
      }

      secretName = "${var.namespace}-tls"

      subject = {
        organizations = [
          "devops"
        ]
        organizationalUnits = [
          "devops"
        ]
      }
    }
  }
}