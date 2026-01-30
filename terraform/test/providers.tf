terraform {
  backend "s3" {}
}

locals {
  config_path    = "/home/phil/PycharmProjects/k8s-platform/talos/config/kubeconfig"
  config_context = "admin@talos-cluster"
}

provider "aws" {
  # this provider is used to upload and fetch ssm params in us-east-1
  alias  = "parameters"
  region = "us-east-1"
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

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
}