locals {
  admins = [
    kubernetes_secret_v1.jenkins_secret.data.jenkins-admin-user
  ]

  admin_list = [for admin in local.admins : { user = admin }]
}