variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "base-alma-9-5"
}

variable "disk_size" {
  description = "Disk size"
  type        = string
  default     = "100G"
}

variable "fleet_domain" {
  description = "Domain"
  type        = string
  default     = "fleet.pafable.com"
}

variable "host_name" {
  description = "VM name"
  type        = string
  default     = "lunchbox"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
  default     = "deployer"
}