variable "password" {
  description = "Password for PVE"
  sensitive   = true
  type        = string
}

variable "proxmox_url" {
  description = "Proxmox api url"
  type        = string
}

variable "username" {
  description = "Username for PVE"
  sensitive   = true
  type        = string
}

variable "ssh_password" {
  description = "ssh username"
  sensitive   = true
  type        = string
}

variable "ssh_username" {
  description = "ssh username"
  sensitive   = true
  type        = string
}