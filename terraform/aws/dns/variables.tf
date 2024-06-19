variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "dns_zone" {
  description = "DNS Zone in Route 53"
  type        = string
}

variable "elb_dns_name" {
  description = "DNS name of ELB"
  type        = string
}

variable "branch" {
  description = "Git branch to deploy"
  type        = string
}

variable "code" {
  description = "location of code"
  type        = string
  default     = "k8s-platform/terraform/dns"
}

variable "commit" {
  description = "Git commit to deploy"
  type        = string
}

variable "owner" {
  description = "Owner of cluster"
  type        = string
  default     = "pafable"
}
