# Karpenter Manifests

Terraform is not able to deploy these until the helm chart for Karpenter in [main.tf](..%2F/..%2Fmodules%2Fkarpenter%2Feks.tf) is installed on the cluster.

This Karpenter helm chart is deployed in the [kube-support](..%2Fkube-support%2Fkarpenter.tf) stage.