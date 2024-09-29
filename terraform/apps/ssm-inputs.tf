data "aws_ssm_parameter" "docker_username" {
  provider = aws.parameters
  name     = "/docker/hub/username"
}

data "aws_ssm_parameter" "docker_password" {
  provider = aws.parameters
  name     = "/docker/hub/password"
}

data "aws_ssm_parameter" "aws_dev_access_key" {
  provider = aws.parameters
  name     = "/account/dev/aws/deployer/access/key/id"
}

data "aws_ssm_parameter" "aws_dev_secret_key" {
  provider = aws.parameters
  name     = "/account/dev/aws/deployer/secret/access/key"
}

data "aws_ssm_parameter" "jenkins_github_token" {
  provider = aws.parameters
  name     = "/jenkins/github/token"
}