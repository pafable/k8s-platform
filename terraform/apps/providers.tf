terraform {
  backend "s3" {}
}

module "aws" {
  source = "../modules/versions/aws"
}

module "terraform_version" {
  source = "../modules/versions/terraform"
}

module "grafana_version" {
  source = "../modules/versions/grafana"
}

provider "aws" {
  # this provider is used to upload and fetch ssm params in us-east-1
  alias  = "parameters"
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    config_path    = var.config_path
    config_context = var.config_context
  }
}

module "helm_version" {
  source = "../modules/versions/helm"
}

provider "kubernetes" {
  config_path    = var.config_path
  config_context = var.config_context
}

module "kubernetes_version" {
  source = "../modules/versions/kubernetes"
}

module "random_version" {
  source = "../modules/versions/random"
}