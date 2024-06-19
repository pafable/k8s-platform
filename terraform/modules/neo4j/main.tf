locals {
  neo4j_chart         = "neo4j-standalone"
  neo4j_chart_repo    = "https://helm.neo4j.com/neo4j"
  neo4j_chart_version = "4.4.30"
  neo4j_name          = "neo4j"
  neo4j_namespace     = "database"
}

resource "helm_release" "neo4j" {
  name             = local.neo4j_name
  repository       = local.neo4j_chart_repo
  chart            = local.neo4j_chart
  version          = local.neo4j_chart_version
  namespace        = kubernetes_namespace_v1.neo4j_ns.metadata.0.name
  create_namespace = true

  values = [
    yamlencode(
      {
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
      }
    )
  ]
}

resource "kubernetes_namespace_v1" "neo4j_ns" {
  metadata {
    name = local.neo4j_namespace
  }
}

resource "kubernetes_secret_v1" "neo4j_secret" {
  metadata {
    name      = "${local.neo4j_name}-secret"
    namespace = kubernetes_namespace_v1.neo4j_ns.metadata.0.name
  }

  data = {
    password = "REPLACE-WITH-YOUR-PW"
  }

  type = "opaque"
}