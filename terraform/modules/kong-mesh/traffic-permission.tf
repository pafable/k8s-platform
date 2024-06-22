## helm_release.kong_mesh needs to be deployed first
## comment this line on the first run on a new cluster
resource "kubernetes_manifest" "default_traffic_permission" {
  count = local.install_count
  manifest = {
    apiVersion = "kuma.io/v1alpha1"
    kind       = "MeshTrafficPermission"

    metadata = {
      name      = "${local.app_name}-default-traffic-permission"
      namespace = kubernetes_namespace_v1.kong_mesh_ns.metadata.0.name
      labels    = local.labels
    }

    spec = {
      targetRef = {
        kind = "Mesh"
      }

      from = [
        {
          targetRef = {
            kind = "Mesh"
          }
          default = {
            action = "Allow"
          }
        }
      ]
    }
  }
  depends_on = [kubernetes_manifest.enable_mtls]
}

resource "kubernetes_manifest" "enable_mtls" {
  count = local.install_count
  manifest = {
    apiVersion = "kuma.io/v1alpha1"
    kind       = "Mesh"

    metadata = {
      name = "default"
    }

    spec = {
      mtls = {
        enabledBackend = "ca-1"
        backends = [
          {
            name = "ca-1"
            type = "builtin"
            dpCert = {
              rotation = {
                expiration = "1d"
              }
            }
            conf = {
              caCert = {
                RSAbits    = 2048
                expiration = "10y"
              }
            }
          }
        ]
      }
    }
  }
  depends_on = [helm_release.kong_mesh]
}
