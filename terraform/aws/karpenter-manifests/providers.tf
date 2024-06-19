terraform {
  required_version = ">= 1.7.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.29.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}