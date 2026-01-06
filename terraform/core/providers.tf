terraform {
  backend "s3" {}
}

locals {
  config_path    = "/Users/pafa/PycharmProjects/k8s-platform/talos/config/kubeconfig"
  config_context = "admin@talos-cluster"
}

provider "aws" {
  # this provider is used to upload and fetch ssm params in us-east-1
  alias  = "parameters"
  region = "us-east-1"
}

provider "helm" {
  kubernetes = {
    config_path    = local.config_path
    config_context = local.config_context
  }
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
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

module "helm_version" {
  source = "../modules/versions/helm"
}

module "kubernetes_version" {
  source = "../modules/versions/kubernetes"
}

module "random_version" {
  source = "../modules/versions/random"
}