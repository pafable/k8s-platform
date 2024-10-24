locals {
  app_name    = "jenkins"
  chart_name  = local.app_name
  jenkins_url = "https://${local.app_name}.${var.domain}"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode(
      {
        agent = {
          alwaysPullImage = true

          envVars = [
            {
              name  = "TZ"
              value = var.timezone
            }
          ]

          image = {
            # My custom image does not work on k3s!
            repository = var.agent_container_repository
            tag        = var.agent_container_tag
          }

          podName    = "${local.app_name}-agent"
          privileged = true

          resources = {
            limits = {
              cpu    = ""
              memory = ""
            }
            requests = {
              cpu    = "1024m"
              memory = "1024Mi"
            }
          }

          # volumes = [
          #   {
          #     # needed by docker because docker.sock is in this dir on the host node
          #     type      = "hostPathVolume"
          #     hostPath  = "/var/run"
          #     mountPath = "/var/run"
          #   }
          # ]
        }

        controller = {
          disableRememberMe             = true
          executorMode                  = "EXCLUSIVE"
          installPlugins                = local.plugins
          installLatestSpecifiedPlugins = true
          jenkinsUrl                    = local.jenkins_url
          jenkinsUrlProtocol            = "https"
          projectNamingStrategy         = "roleBased"

          admin = {
            existingSecret = kubernetes_secret_v1.jenkins_secret.metadata[0].name
          }

          containerEnv = [
            {
              name  = "TZ"
              value = var.timezone
            }
          ]

          JCasC = {
            configScripts = local.jcasc_scripts_map

            authorizationStrategy = tostring(
              yamlencode(
                {
                  roleBased = {
                    roles = {
                      global = [
                        {
                          description = "Jenkins Administrators"
                          entries     = local.admin_list
                          name        = "admin"
                          pattern     = ".*"
                          permissions = ["Overall/Administer"]
                        },
                        {
                          description = "Jenkins Read Only"
                          entries     = null
                          name        = "read-only"
                          pattern     = ".*"
                          permissions = [
                            "Overall/Read",
                            "Job/Read",
                            "Metrics/View",
                            "View/Read"
                          ]
                        }
                      ]
                    }
                  }
                }
              )
            )
          }
        }

        persistence = {
          existingClaim = kubernetes_persistent_volume_claim_v1.jenkins_pvc.metadata[0].name
        }

        rbac = {
          readSecrets = true
        }
      }
    )
  ]
}

resource "kubernetes_namespace_v1" "jenkins_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "random_password" "password" {
  length = 25
}

resource "kubernetes_secret_v1" "jenkins_secret" {
  metadata {
    name      = "${local.app_name}-secrets"
    namespace = kubernetes_namespace_v1.jenkins_ns.metadata[0].name
    labels    = local.labels
  }

  data = {
    jenkins-admin-user     = "${local.app_name}-admin"
    jenkins-admin-password = sensitive(random_password.password.result)
  }

  type = "Opaque"
}

resource "kubernetes_persistent_volume_claim_v1" "jenkins_pvc" {
  metadata {
    name      = "${local.app_name}-pvc"
    namespace = kubernetes_namespace_v1.jenkins_ns.metadata[0].name
    labels    = local.labels
  }

  spec {
    storage_class_name = var.storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_v1" "jenkins_pv" {
  metadata {
    name   = "${local.app_name}-pv"
    labels = local.labels
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.storage_class_name
    persistent_volume_source {
      host_path {
        path = "/tmp"
      }
    }
  }
}

resource "helm_release" "jenkins" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.jenkins_ns.metadata.0.name
  repository        = var.helm_repo
  values            = local.values
  timeout           = var.timeout
  version           = var.helm_chart_version
}