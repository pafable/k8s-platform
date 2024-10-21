variable "domain" {
  description = "domain"
  type        = string
  default     = "home.pafable.com"
}

variable "ingress_name" {
  description = "Ingress to use"
  type        = string
  default     = "nginx"
}

variable "is_dev" {
  description = "Is this a dev environment"
  type        = bool
  default     = false
}

variable "ou" {
  description = "Organization unit"
  type        = string
  default     = "devops"
}

variable "owner" {
  description = "Owner"
  type        = string
  default     = "devops"
}

variable "vault_version" {
  description = "Vault helm chart version"
  type        = string
  default     = "0.28.1"
}