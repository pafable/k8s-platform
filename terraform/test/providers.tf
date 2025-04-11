terraform {
  backend "s3" {}
}

module "aws" {
  source = "../modules/versions/aws"
}

module "terraform_version" {
  source = "../modules/versions/terraform"
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner = "pafable"
    }
  }
}
