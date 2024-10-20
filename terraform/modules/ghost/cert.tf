resource "kubernetes_manifest" "cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "ghost-cert"
      namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name # certs are bound to namespaces
      labels = {
        app   = var.app_name
        owner = local.owner
      }
    }

    spec = {
      commonName = local.domain_name

      dnsNames = [
        "ghost.local"
      ]

      isCA = true

      issuerRef = {
        name = local.self_signed_ca_name
        kind = "ClusterIssuer"
      }

      privateKey = {
        algorithm = "ECDSA"
        encoding  = "PKCS1"
        size      = 256
      }

      secretName = "${var.app_name}-tls"

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