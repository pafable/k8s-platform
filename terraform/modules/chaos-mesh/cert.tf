resource "kubernetes_manifest" "cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "chaos-mesh-self-signed-cert"
      namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name # certs are bound to namespaces
      labels = {
        app   = local.app_name
        owner = var.owner
      }
    }

    spec = {
      commonName = local.domain_name

      dnsNames = [
        local.domain_name
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