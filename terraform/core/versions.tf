module "aws" {
  source = "../modules/versions/aws"
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

module "terraform_version" {
  source = "../modules/versions/terraform"
}