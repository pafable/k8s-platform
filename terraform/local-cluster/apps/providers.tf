locals {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

module "terraform_version" {
  source = "../../modules/versions/terraform"
}

module "grafana_version" {
  source = "../../modules/versions/grafana"
}

provider "helm" {
  kubernetes {
    config_path    = local.config_path
    config_context = local.config_context
  }
}

module "helm_version" {
  source = "../../modules/versions/helm"
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
}

module "kubernetes_version" {
  source = "../../modules/versions/kubernetes"
}

module "random_version" {
  source = "../../modules/versions/random"
}