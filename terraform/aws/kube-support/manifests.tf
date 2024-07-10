# Creates a karpenter node pool in the karpenter namespace
resource "kubernetes_manifest" "main_karpenter_node_pool" {
  manifest = {
    apiVersion = "karpenter.sh/v1beta1"
    kind       = "NodePool"

    metadata = {
      name = "${local.cluster_name}-main-karpenter-node-pool"
    }

    spec = {
      template = {
        spec = {
          requirements = [
            {
              key      = "kubernetes.io/arch"
              operator = "In"
              values   = ["amd64"]
            },
            {
              key      = "kubernetes.io/os"
              operator = "In"
              values   = ["linux"]
            },
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = ["spot"]
            },
            {
              key      = "node.kubernetes.io/instance-type"
              operator = "In"
              values   = ["t2.micro", "t3.micro", "t3.medium", "t3.large"]
            }
          ]

          nodeClassRef = {
            apiVersion = "karpenter.k8s.aws/v1beta1"
            kind       = "EC2NodeClass"
            name       = "${local.cluster_name}-main-karpenter-node-class"
          }
        }
      }

      limits = {
        cpu = 1000
      }

      disruption = {
        consolidationPolicy = "WhenUnderutilized"
        expireAfter         = "720h" # 30d * 24h = 720h
      }
    }
  }
}

# Creates a karpenter node class
resource "kubernetes_manifest" "main_karpenter_node_class" {
  manifest = {
    apiVersion = "karpenter.k8s.aws/v1beta1"
    kind       = "EC2NodeClass"

    metadata = {
      name = "${local.cluster_name}-main-karpenter-node-class"
    }

    spec = {
      amiFamily = "AL2"
      role      = module.karpenter.node_iam_role_name

      subnetSelectorTerms = [
        {
          tags = {
            "karpenter.sh/discovery" = local.cluster_name
          }
        }
      ]

      securityGroupSelectorTerms = [
        {
          tags = {
            "karpenter.sh/discovery" = local.cluster_name
          }
        }
      ]

      tags = {
        Name          = "${local.cluster_name}-karpenter-node"
        owner         = var.owner
        code_location = var.code
      }
    }
  }
}
