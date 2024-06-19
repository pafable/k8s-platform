resource "aws_ec2_client_vpn_endpoint" "_" {
  client_cidr_block      = var.client_cidr_block
  description            = "${var.name} vpn endpoint"
  security_group_ids     = [aws_security_group._.id]
  server_certificate_arn = aws_acm_certificate._.arn
  session_timeout_hours  = 8
  split_tunnel           = var.enable_split_tunnel
  transport_protocol     = "udp"
  vpc_id                 = var.vpc_id

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate._.arn
  }

  client_login_banner_options {
    banner_text = var.client_banner
    enabled     = true
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group._.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream._.name
  }

  dns_servers = [var.dns_server, "1.1.1.1"]
}

resource "aws_ec2_client_vpn_network_association" "_" {
  for_each               = toset(nonsensitive(var.subnet_ids))
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint._.id
  subnet_id              = each.value

  lifecycle {
    ignore_changes = [subnet_id]
  }
}

resource "aws_ec2_client_vpn_route" "_" {
  for_each               = toset(nonsensitive(slice(var.subnet_ids, 0, 1)))
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint._.id
  destination_cidr_block = var.destination_cidr
  target_vpc_subnet_id   = each.value

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "_" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint._.id
  description            = "Allow internet access"
  target_network_cidr    = var.destination_cidr
  authorize_all_groups   = true

  timeouts {
    create = "30m"
    delete = "30m"
  }
}