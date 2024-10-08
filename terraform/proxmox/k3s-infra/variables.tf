variable "k3s_token" {
  description = "k3s token"
  type        = string
  sensitive   = true
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "provisioner"
}