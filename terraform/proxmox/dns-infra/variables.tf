variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = "dns.tmpl.005"
}

variable "host_name" {
  description = "VM name"
  type        = string
  default     = "ns1"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
  default     = "deployer"
}