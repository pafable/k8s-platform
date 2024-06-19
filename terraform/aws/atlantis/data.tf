# COMMENT THIS TO DEPLOY TO A LOCAL CLUSTER (Docker Desktop, minikube)
data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

# COMMENT THIS TO DEPLOY TO A LOCAL CLUSTER (Docker Desktop, minikube)
data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.eks_cluster_name
}