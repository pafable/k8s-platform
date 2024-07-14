locals {
  neo4j_chart      = "neo4j-standalone"
  neo4j_chart_repo = "https://helm.neo4j.com/neo4j"
  neo4j_name       = "neo4j"

  labels = {
    "app.kubernetes.io/app"        = local.neo4j_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      neo4j = {
        name                   = local.neo4j_name
        password               = "<?????>"
        acceptLicenseAgreement = "yes"
      }

      volumes = {
        data = {
          mode = "defaultStorageClass"
          defaultStorageClass = {
            storage = "2Gi"
          }
        }
      }
    })
  ]
}

resource "helm_release" "neo4j" {
  chart             = local.neo4j_chart
  create_namespace  = false
  dependency_update = true
  name              = local.neo4j_name
  namespace         = kubernetes_namespace_v1.neo4j_ns.metadata.0.name
  repository        = local.neo4j_chart_repo
  values            = local.values
  version           = var.helm_chart_version
}

resource "kubernetes_namespace_v1" "neo4j_ns" {
  metadata {
    name   = local.neo4j_name
    labels = local.labels
  }
}

resource "kubernetes_secret_v1" "neo4j_secret" {
  metadata {
    name      = "${local.neo4j_name}-secret"
    namespace = kubernetes_namespace_v1.neo4j_ns.metadata.0.name
    labels    = local.labels
  }

  data = {
    password = "REPLACE-WITH-YOUR-PW"
  }

  type = "opaque"
}