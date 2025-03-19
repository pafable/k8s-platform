variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "alm.tmpl.000"
}

variable "host_name" {
  description = "VM name"
  type        = string
  default     = "dns"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
  default     = "deployer"
}