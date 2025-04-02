variable "domain" {
  description = "domain"
  type        = string
  default     = "home.pafable.com"
}

variable "ingress_name" {
  description = "Ingress to use"
  type        = string
  default     = "nexus"
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

variable "nexus_version" {
  description = "Vault helm chart version"
  type        = string
  default     = "79.0.0"
}

variable "nfs_ipv4" {
  description = "IP address of NFS server for storage backend"
  type        = string
}

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
  default     = "bar"
}