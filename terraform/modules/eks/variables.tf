variable "client_vpn_security_group_id" {
  description = "Client VPN security group id"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "enable_public_access" {
  description = "enable public access of api server/control plane"
  type        = bool
  default     = false
}

variable "instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "intra_subnet_ids" {
  description = "EKS intra subnets"
  type        = list(string)
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = 1.29
}

variable "max_unavailable" {
  description = "Max unavailable worker nodes"
  type        = number
  default     = 25
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Max number of worker nodes"
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Min number of worker nodes"
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "EKS private subnets"
  type        = list(string)
}

variable "sso_role_arn" {
  description = "AWS SSO role arn"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}