variable "ca_cert" {
  description = "CA cert"
  type        = string
  sensitive   = true
}

variable "ca_key" {
  description = "CA private key"
  type        = string
  sensitive   = true
}

variable "cert_manager_version" {
  description = "Cert Manager version"
  type        = string
  default     = "v1.15.2"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops"
}