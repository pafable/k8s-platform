locals {
  app_set = toset([
    "atlantis",
    "ghost"
  ])

  # default tags
  default_tags = {
    branch        = var.branch
    code_location = var.code
    commit_id     = var.commit
    managed_by    = "terraform"
    owner         = var.owner
  }
}

resource "aws_route53_record" "r53_record" {
  for_each = local.app_set
  name     = "${each.value}.${var.dns_zone}"
  type     = "A"
  zone_id  = data.aws_route53_zone.selected.zone_id

  alias {
    evaluate_target_health = true
    name                   = var.elb_dns_name
    zone_id                = data.aws_elb_hosted_zone_id.main.id
  }
}