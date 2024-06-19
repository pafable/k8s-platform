locals {
  self_signed_ca_name = "self-signed-cluster-ca-issuer"
}

resource "kubernetes_manifest" "pgadmin_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.pg_name}-self-signed-cert"
      namespace = kubernetes_namespace_v1.postgresql_ns.metadata.0.name # certs are bound to namespaces

      labels = {
        app   = "${local.pg_name}-server"
        owner = var.owner
      }
    }

    spec = {
      commonName = local.pgadmin_domain

      dnsNames = [
        "pgadmin.localhost",
        "pgadmin.local"
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