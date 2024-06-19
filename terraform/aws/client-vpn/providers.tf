terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}