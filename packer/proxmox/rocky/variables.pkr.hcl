variable "proxmox_node" {
  description = "Proxmox node"
  type        = string
}

variable "proxmox_password" {
  description = "Password for PVE"
  sensitive   = true
  type        = string
}

variable "proxmox_url" {
  description = "Proxmox api url"
  type        = string
}

variable "proxmox_username" {
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

variable "template_name" {
  description = "Template name"
  type        = string
}