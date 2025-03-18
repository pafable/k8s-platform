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
        # clusterZone = var.domain

        additionalAgents = {
          kaniko = {
            alwaysPullImage = true
            componentName   = "kaniko-agent"

            image = {
              repository = "gcr.io/kaniko-project/executor"
              tag        = "debug"
            }

            nodeUsageMode     = "EXCLUSIVE"
            podName           = "kaniko-agent"
            privileged        = true
            sideContainerName = "kaniko"
          }
        }

        agent = {
          alwaysPullImage = true
          # # this is necessary because labels on the pod template will be set to "jenkins-${podName}"
          componentName = "agent"

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
              memory = "1024Mi"
            }

            requests = {
              cpu    = "1024m"
              memory = "1024Mi"
            }
          }
        }

        controller = {
          disableRememberMe             = true
          executorMode                  = "EXCLUSIVE"
          hostName                      = local.domain
          installPlugins                = local.plugins
          installLatestSpecifiedPlugins = true
          jenkinsUrl                    = local.jenkins_url
          jenkinsUrlProtocol            = "https"
          projectNamingStrategy         = "roleBased"

          admin = {
            existingSecret = kubernetes_secret_v1.jenkins_admin_secret.metadata[0].name
          }

          containerEnv = [
            {
              name  = "TZ"
              value = var.timezone
            }
          ]

          ingress = {
            enabled    = true
            apiVersion = "networking.k8s.io/v1"

            annotations = {
              "kubernetes.io/ingress.class" = var.ingress_name
              "kubernetes.io/ssl-redirect"  = "true"
            }

            paths = [
              {
                path     = "/"
                pathType = "Prefix"

                backend = {
                  service = {
                    name = local.service_name
                    port = {
                      number = local.port
                    }
                  }
                }
              }
            ]

            tls = [
              {
                hosts      = [local.domain]
                secretName = kubernetes_manifest.jenkins_cert.manifest.spec.secretName
              }
            ]
          }

          JCasC = {
            configScripts          = local.jcasc_scripts_map
            overwriteConfiguration = true

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

          # overrideArgs = [
          #   "--httpsCertificate=/var/jenkins-certs/${local.domain}.crt",
          #   "--httpsPrivateKey=/var/jenkins-certs/${local.domain}-key.pem"
          # ]
        }

        persistence = {
          existingClaim = kubernetes_persistent_volume_claim_v1.jenkins_pvc.metadata[0].name

          mounts = [
            {
              mountPath = "/var/jenkins-certs"
              name      = "jenkins-certs"
              readOnly  = false
            }
          ]

          volumes = [
            {
              name = "jenkins-certs"
              secret = {
                secretName = "jenkins-certs"
              }
            }
          ]
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

resource "kubernetes_secret_v1" "jenkins_admin_secret" {
  metadata {
    name      = "${local.app_name}-admin-secret"
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
    access_modes       = ["ReadWriteMany"]

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

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.storage_class_name

    persistent_volume_source {
      nfs {
        path   = "/volume2/fs/jenkins"
        server = var.nfs_ipv4
      }
    }
  }
}

resource "kubernetes_secret_v1" "jenkins_tls_certs" {
  metadata {
    name      = "${local.app_name}-certs"
    namespace = kubernetes_namespace_v1.jenkins_ns.metadata[0].name
  }

  data = {
    "${local.domain}-key.pem" = var.cert_private_key
    "${local.domain}.crt"     = var.cert
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