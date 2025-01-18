locals {
  # EKS cluster params
  ami_type                     = "AL2_x86_64"
  capacity_type                = "SPOT"
  disk_size                    = 30
  eks_cluster_admin_policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  enable_cluster_creator       = true
  log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  most_recent_addon            = true
  resolve_conflict             = "OVERWRITE"
  sso_role_admin_arn           = var.sso_role_arn

  additional_worker_policy_keys = [
    "amazon_cloudwatch_agent_server",
    "amazon_ebs_csi_driver",
    "amazon_ec2_container_registry_ro",
    "amazon_eks_cni",
    "amazon_eks_worker_node",
    "amazon_ssm_managed_instance_core"
  ]

  additional_worker_policy_values = [
    "CloudWatchAgentServerPolicy",
    "service-role/AmazonEBSCSIDriverPolicy",
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonEKS_CNI_Policy",
    "AmazonEKSWorkerNodePolicy",
    "AmazonSSMManagedInstanceCore"
  ]

  additional_worker_policies = {
    for i in range(length(local.additional_worker_policy_keys))
    : local.additional_worker_policy_keys[i] => "arn:${data.aws_partition.current.partition}:iam::aws:policy/${local.additional_worker_policy_values[i]}"
  }
  ## creates this
  # {
  #   amazon_cloudwatch_agent_server   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
  #   amazon_ebs_csi_driver            = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  #   amazon_ec2_container_registry_ro = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  #   amazon_eks_cni                   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  #   amazon_eks_worker_node           = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  #   amazon_ssm_managed_instance_core = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  # }

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

    launch_template_tags = {
      Name = "${var.cluster_name}-node"
    }

    update_config = {
      max_unavailable_percentage = var.max_unavailable
    }
  }

  private_subnet_tags = {
    "karpenter.sh/discovery" = var.cluster_name # Karpenter discovery tag for private subnets only
  }
}