locals {
  admins = [
    "jenkins-user"
  ]

  admin_list = [for admin in local.admins : { user = admin }]

  read_only = [
    "ro-user-1",
    "ro-user-2"
  ]

  ro_list = [for ro in local.read_only : { user = ro }]
}