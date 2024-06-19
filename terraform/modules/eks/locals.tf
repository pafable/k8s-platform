locals {
  # EKS cluster params
  ami_type                     = "AL2_x86_64"
  capacity_type                = "SPOT"
  cluster_name                 = var.cluster_name
  disk_size                    = 30
  eks_cluster_admin_policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  enable_cluster_creator       = true
  enable_nat_gateway           = true
  enable_public_access         = true
  log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  min_healthy_percentage       = 33
  most_recent_addon            = true
  resolve_conflict             = "OVERWRITE"
  single_nat_gateway           = true
  sso_role_pafa_admin_arn      = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/<YOUR_SSO_ROLE_ARN>"

  additional_worker_policies = {
    amazon_cloudwatch_agent_server   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
    amazon_ebs_csi_driver            = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    amazon_ec2_container_registry_ro = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    amazon_eks_cni                   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
    amazon_eks_worker_node           = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    amazon_ssm_managed_instance_core = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  cluster_addons = {
    amazon-cloudwatch-observability = {
      most_recent      = local.most_recent_addon
      resolve_conflict = local.resolve_conflict
    }

    aws-ebs-csi-driver = {
      most_recent      = local.most_recent_addon
      resolve_conflict = local.resolve_conflict
    }

    coredns = {
      most_recent      = local.most_recent_addon
      resolve_conflict = local.resolve_conflict
    }

    eks-pod-identity-agent = { # required by karpenter
      most_recent      = local.most_recent_addon
      resolve_conflict = local.resolve_conflict
    }

    kube-proxy = {
      most_recent      = local.most_recent_addon
      resolve_conflict = local.resolve_conflict
    }

    vpc-cni = {
      most_recent      = local.most_recent_addon
      resolve_conflict = local.resolve_conflict
    }
  }

  eks_managed_node_group_defaults = {
    iam_role_additional_policies = local.additional_worker_policies
  }

  eks_managed_node_groups = {
    main-nodes = local.main_node_group
  }

  main_node_group = {
    ami_type               = local.ami_type
    bootstrap_extra_args   = "--kubelet-extra-args '--node-labels=node-group=main'"
    capacity_type          = local.capacity_type
    instance_types         = toset(var.instance_types)
    disk_size              = local.disk_size
    desired_size           = var.node_desired_size
    max_size               = var.node_max_size
    min_size               = var.node_min_size
    vpc_security_group_ids = [aws_security_group.allow_all_ingress_sg.id]

    launch_template_tags = { Name = "${local.cluster_name}-node" }
  }

  private_subnet_tags = {
    "karpenter.sh/discovery" = local.cluster_name # Karpenter discovery tag for private subnets only
  }
}