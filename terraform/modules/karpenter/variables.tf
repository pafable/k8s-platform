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

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "0.37.0"
}

variable "oidc_provider_arn" {
  description = "OIDC provider Arn"
  type        = string
}

variable "owner" {
  description = "Owner of resource"
  type        = string
}