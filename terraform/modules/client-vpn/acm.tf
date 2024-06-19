resource "aws_acm_certificate" "_" {
  private_key       = var.server_private_key
  certificate_body  = var.server_cert
  certificate_chain = var.ca_cert
} 