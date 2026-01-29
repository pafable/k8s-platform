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