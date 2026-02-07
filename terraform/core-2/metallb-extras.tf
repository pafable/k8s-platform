locals {
  labels = {
    jobLabel                       = "core"
    "app.kubernetes.io/name"       = "core"
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = "devops"
  }
}

resource "kubernetes_manifest" "ip_address_pool" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"

    metadata = {
      name      = "core-cluster-address-pool"
      namespace = "metallb-system"
      labels    = local.labels
    }

    spec = {
      addresses = [
        "10.0.50.2-10.0.50.25"
      ]
    }
  }
}

resource "kubernetes_manifest" "advertisment" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"

    metadata = {
      name      = "core-cluster-adverisement"
      namespace = "metallb-system"
      labels    = local.labels
    }

    spec = {
      ipAddressPools = [
        kubernetes_manifest.ip_address_pool.manifest.metadata.name
      ]
    }
  }
}