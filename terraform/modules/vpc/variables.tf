variable "name" {
  description = "The name of the VPC"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT gateways for the private subnets"
  type        = bool
  default     = true
}

variable "enable_karpenter_subnet_tag" {
  description = "Whether to put the karpenter subnet tag on private subnets"
  type        = bool
  default     = false
}

variable "intra_subnets" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "EKS private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "EKS public subnets"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT gateway for all private subnets"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}