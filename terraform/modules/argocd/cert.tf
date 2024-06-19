locals {
  self_signed_ca_name = "self-signed-cluster-ca-issuer"
}

resource "kubernetes_manifest" "argocd_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "${local.app_name}-self-signed-cert"
      namespace = kubernetes_namespace_v1.argocd_ns.metadata.0.name # certs are bound to namespaces

      labels = {
        app   = "${local.app_name}-server"
        owner = var.owner
      }
    }

    spec = {
      commonName = local.argo_domain

      dnsNames = [
        "${local.app_name}.localhost",
        "${local.app_name}.local"
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