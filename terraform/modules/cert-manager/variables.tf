variable "cert_manager_version" {
  description = "Cert Manager version"
  type        = string
  default     = "v1.15.1"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops"
}