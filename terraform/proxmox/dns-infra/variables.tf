variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "uwutest"
}

variable "host_name" {
  description = "VM name"
  type        = string
  default     = "dns-01"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
  default     = "provisioner"
}