module "new_eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = ">= 20.8.5"
  control_plane_subnet_ids                 = var.intra_subnet_ids # control plane will be deployed in this subnet
  cluster_enabled_log_types                = local.log_types
  cluster_name                             = var.cluster_name
  cluster_version                          = var.k8s_version
  cluster_endpoint_public_access           = var.enable_public_access
  enable_cluster_creator_admin_permissions = local.enable_cluster_creator
  subnet_ids                               = var.private_subnet_ids # worker nodes will be deployed in this subnet
  vpc_id                                   = var.vpc_id

  access_entries = {
    sso__admin = {
      principal_arn = local.sso_role_admin_arn
      policy_associations = {
        admin = {
          policy_arn = local.eks_cluster_admin_policy_arn
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  #   cluster_security_group_additional_rules = {
  #     # allows https traffic from client vpn
  #     # this is needed for access to EKS control plane from VPN network
  #     ingress_from_client_vpn = {
  #       description              = "allow all inbound traffic from client vpn"
  #       protocol                 = "tcp"
  #       from_port                = 443
  #       to_port                  = 443
  #       type                     = "ingress"
  #       source_security_group_id = var.client_vpn_security_group_id
  #     }
  #   }

  cluster_addons                  = local.cluster_addons
  eks_managed_node_groups         = local.eks_managed_node_groups
  eks_managed_node_group_defaults = local.eks_managed_node_group_defaults

  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }

  ## this is a test
  #   node_security_group_additional_rules = {
  #     ingress_self_all = {
  #       description = "allow all inbound traffic to nodes"
  #       protocol    = "-1"
  #       from_port   = 0
  #       to_port     = 0
  #       type        = "ingress"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     }
  #   }
}