locals {
  issuer = "self-signed-ca-cluster-issuer"
}

resource "kubernetes_manifest" "pgadmin_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.pg_name}-self-signed-cert"
      namespace = kubernetes_namespace_v1.postgresql_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.labels
    }

    spec = {
      commonName = local.pgadmin_domain

      dnsNames = [
        local.pgadmin_domain
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

      secretName = "${local.pg_name}-tls"

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