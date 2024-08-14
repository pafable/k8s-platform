locals {
  admins = [
    "jenkins-user"
  ]

  admin_list = [for admin in local.admins : { user = admin }]
}