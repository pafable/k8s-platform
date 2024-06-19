resource "aws_security_group" "_" {
  name        = "client-vpn-${var.name}"
  description = "Client VPN Endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "in" {
  type              = "ingress"
  description       = "Inbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group._.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "out" {
  type              = "egress"
  description       = "Outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group._.id
  cidr_blocks       = ["0.0.0.0/0"]
} 