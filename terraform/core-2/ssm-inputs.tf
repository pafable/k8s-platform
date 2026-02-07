data "aws_ssm_parameter" "ca_cert" {
  provider = aws.parameters
  name     = "/ca/cert"
}

data "aws_ssm_parameter" "ca_private_key" {
  provider = aws.parameters
  name     = "/ca/private/key"
}