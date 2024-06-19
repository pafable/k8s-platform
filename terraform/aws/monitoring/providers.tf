terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.1"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}