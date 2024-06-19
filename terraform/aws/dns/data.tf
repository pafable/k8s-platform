data "aws_route53_zone" "selected" {
  name = var.dns_zone
}

data "aws_elb_hosted_zone_id" "main" {}