module "aws_auth" {
  for_each = local.sso_role_arns
  source   = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version  = "20.8.0"

  aws_auth_roles = [
    {
      role_arn = each.value
      username = "admin"
      groups   = ["system:masters"]
    }
  ]
}