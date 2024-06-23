locals {
  name = "karpenter"

  labels = {
    "app.kubernetes.io/app"        = local.name
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "karpenter_ns" {
  metadata {
    name   = local.name
    labels = local.labels
  }
}

# This creates AWS resources for Karpenter. It does not install the Karpenter Helm chart.
module "karpenter" {
  source                 = "terraform-aws-modules/eks/aws//modules/karpenter"
  version                = ">= 20.8.5"
  cluster_name           = var.cluster_name
  enable_irsa            = true
  irsa_oidc_provider_arn = var.oidc_provider_arn

  node_iam_role_additional_policies = {
    amazon_ebs_csi_driver            = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    amazon_ec2_container_registry_ro = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    amazon_eks_cni                   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
    amazon_eks_worker_node           = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    amazon_ssm_managed_instance_core = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

# This will install Karpenter kubernetes resources onto a cluster
resource "helm_release" "karpenter" {
  namespace           = local.name
  create_namespace    = true
  name                = local.name
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = local.name
  timeout             = 500
  version             = var.helm_chart_version
  wait                = false

  values = [
    yamlencode(
      {
        settings = {
          clusterName       = var.cluster_name
          clusterEndpoint   = var.cluster_endpoint
          interruptionQueue = module.karpenter.queue_name
        }
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = module.karpenter.iam_role_arn
          }
        }
      }
    )
  ]
}
