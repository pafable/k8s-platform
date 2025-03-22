variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "dns.tmpl.001"
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