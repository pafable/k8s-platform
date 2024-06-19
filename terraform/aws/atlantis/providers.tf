terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.2.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.29.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  token = var.github_token
}

# UNCOMMENT THIS TO DEPLOY TO A LOCAL CLUSTER (Docker Desktop, minikube)
# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "docker-desktop"
# }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}