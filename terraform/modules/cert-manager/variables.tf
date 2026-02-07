variable "cert_manager_version" {
  description = "Cert Manager version"
  type        = string
  default     = "v1.19.3"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops"
}

variable "ca_cert" {
  description = "CA cert in base64"
  type        = string
  sensitive   = true
}

variable "ca_key" {
  description = "CA private key in base64"
  type        = string
  sensitive   = true
}