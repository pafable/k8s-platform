module "aws_auth" {
  for_each = nonsensitive(local.sso_role_arns)
  source   = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version  = "20.17.2"

  aws_auth_roles = [
    {
      role_arn = each.value
      username = "admin"
      groups   = ["system:masters"]
    }
  ]
}