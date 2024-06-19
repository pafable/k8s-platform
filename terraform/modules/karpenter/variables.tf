variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "code" {
  description = "Code location"
  type        = string
}

variable "karpenter_module_version" {
  description = "Karpenter module version"
  type        = string
  default     = "20.8.5"
}

variable "oidc_provider_arn" {
  description = "OIDC provider Arn"
  type        = string
}

variable "owner" {
  description = "Owner of resource"
  type        = string
}