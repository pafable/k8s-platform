resource "kubernetes_manifest" "cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "monitoring-cert"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.labels
    }

    spec = {
      commonName = local.prom_domain

      dnsNames = [
        "grafana.home.pafable.com",
        "loki.home.pafable.com",
        "prom.home.pafable.com",
        "prometheus.home.pafable.com"
      ]

      isCA = true

      issuerRef = local.issuer

      privateKey = {
        algorithm = "ECDSA"
        encoding  = "PKCS1"
        size      = 256
      }

      secretName = "kube-prom-tls"

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