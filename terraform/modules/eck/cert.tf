locals {
  self_signed_ca_name = "self-signed-cluster-ca-issuer"
}

resource "kubernetes_manifest" "kibana_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.kibana_name}-self-signed-cert"
      namespace = kubernetes_namespace_v1.eck_op_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.labels
    }

    spec = {
      commonName = local.kibana_domain

      dnsNames = [
        "${local.kibana_name}.localhost",
        "${local.kibana_name}.local"
      ]

      isCA = true

      issuerRef = {
        name = local.self_signed_ca_name
        kind = "ClusterIssuer"
      }

      privateKey = {
        algorithm = "ECDSA"
        encoding  = "PKCS1"
        size      = 521
      }

      secretName = "${local.kibana_name}-tls"

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

  depends_on = [helm_release.eck_stack]
}