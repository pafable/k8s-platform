data "aws_ssm_parameter" "docker_username" {
  provider = aws.parameters
  name     = "/docker/hub/username"
}

data "aws_ssm_parameter" "docker_password" {
  provider = aws.parameters
  name     = "/docker/hub/password"
}