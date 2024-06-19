module "aws" {
  source = "../../modules/versions/aws"
}

terraform {
  required_version = ">= 1.8.0"
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  # this provider is used to upload and fetch ssm params in us-east-1
  alias  = "parameters"
  region = "us-east-1"

  default_tags {
    tags = local.default_tags
  }
}