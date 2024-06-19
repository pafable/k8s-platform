locals {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

module "terraform_version" {
  source = "../versions/terraform"
}

module "kubernetes_version" {
  source = "../versions/kubernetes"
}

module "helm_version" {
  source = "../versions/helm"
}

provider "helm" {
  kubernetes {
    config_path    = local.config_path
    config_context = local.config_context
  }
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
}
