resource "kubernetes_manifest" "cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "monitoring-self-signed-cert"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name # certs are bound to namespaces
      labels    = local.labels
    }

    spec = {
      commonName = local.prom_domain

      dnsNames = [
        "grafana.home.pafable.com",
        "grafana.home.pafable.com",
        "prom.home.pafable.com",
        "prometheus.home.pafable.com"
      ]

      isCA = false

      issuerRef = local.issuerRef

      # privateKey = {
      #   algorithm = "ECDSA"
      #   encoding  = "PKCS1"
      #   size      = 256
      # }

      secretName = "prometheus-tls"

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