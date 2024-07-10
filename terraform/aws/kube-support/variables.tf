variable "aws_region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "branch" {
  description = "Git branch to deploy"
  type        = string
}

variable "code" {
  description = "location of code"
  type        = string
  default     = "k8s-platform/terraform/apps/eks"
}

variable "owner" {
  description = "Owner of cluster"
  type        = string
  default     = "YOUR-NAME-HERE"
}
