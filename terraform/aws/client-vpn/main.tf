locals {
  cidr_block         = "10.10.0.0/16"
  client_banner      = "Hello, world!"
  dns_server_address = "10.1.0.2"

  # default tags
  default_tags = {
    app_name      = "xyz"
    branch        = var.branch
    code_location = "k8s-platform/terraform/apps/client-vpn"
    managed_by    = "terraform"
    Name          = "xyz-client-vpn"
    owner         = "pafable"
  }
}

module "client_vpn" {
  source              = "../../modules/client-vpn"
  ca_cert             = data.aws_ssm_parameter.ca_cert.value
  client_banner       = local.client_banner
  client_cidr_block   = local.cidr_block
  dns_server          = local.dns_server_address
  enable_split_tunnel = false
  name                = local.default_tags.app_name
  server_cert         = trimspace(file("cert/server.crt"))
  server_private_key  = data.aws_ssm_parameter.server_private_key.value
  subnet_ids          = jsondecode(data.aws_ssm_parameter.private_subnet_ids.value)
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
}