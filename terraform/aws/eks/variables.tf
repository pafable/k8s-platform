variable "aws_region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "code" {
  description = "location of code"
  type        = string
  default     = "k8s-platform/terraform/eks"
}

variable "owner" {
  description = "Owner"
  type        = string
  default     = "YOUR-NAME-HERE"
}