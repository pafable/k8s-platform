module "aws" {
  source = "../../modules/versions/aws"
}

module "helm" {
  source = "../../modules/versions/helm"
}

module "kubernetes" {
  source = "../../modules/versions/kubernetes"
}

terraform {
  required_version = ">= 1.8.0"
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

  default_tags {
    tags = local.default_tags
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}