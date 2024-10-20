resource "kubernetes_manifest" "cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "chaos-mesh-cert"
      namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.labels
    }

    spec = {
      commonName = local.domain_name

      dnsNames = [
        local.domain_name
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
}