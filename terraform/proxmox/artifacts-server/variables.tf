variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "roc1"
}

variable "disk_size" {
  description = "Disk size"
  type        = string
  default     = "200G"
}

variable "host_name" {
  description = "VM name"
  type        = string
  default     = "rpm-srv"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
  default     = "provisioner"
}