variable "branch" {
  description = "Git branch to deploy"
  type        = string
}

variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform/terraform/karpenter-manifests"
}

variable "owner" {
  description = "Owner"
  type        = string
  default     = "YOUR-NAME-HERE"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}