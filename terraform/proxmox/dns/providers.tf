module "aws" {
  source = "../../modules/versions/aws"
}

module "dns" {
  source = "../../modules/versions/dns"
}

module "terraform_version" {
  source = "../../modules/versions/terraform"
}

terraform {
  backend "s3" {}
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}

provider "dns" {
  update {
    server        = data.aws_ssm_parameter.dns_server_ip.value
    key_name      = "tsig-key."
    key_algorithm = "hmac-sha256"
    key_secret    = sensitive(data.aws_ssm_parameter.tsig_key.value)
  }
}