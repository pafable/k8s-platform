terraform {
  backend "s3" {}
}

module "aws" {
  source = "../modules/versions/aws"
}

module "helm_version" {
  source = "../modules/versions/helm"
}

module "kubernetes_version" {
  source = "../modules/versions/kubernetes"
}

provider "aws" {
  # this provider is used to upload and fetch ssm params in us-east-1
  alias  = "parameters"
  region = "us-east-1"
}

provider "helm" {
  kubernetes = {
    config_path    = var.config_path
    config_context = var.config_context
  }
}

provider "kubernetes" {
  config_path    = var.config_path
  config_context = var.config_context
}