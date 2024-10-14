variable "domain" {
  description = "domain"
  type        = string
  default     = "home.pafable.com"
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