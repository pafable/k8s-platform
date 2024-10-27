variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "uwutest"
}

variable "name" {
  description = "VM name"
  type        = string
  default     = "phil-ubu-vm"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
  default     = "provisioner"
}