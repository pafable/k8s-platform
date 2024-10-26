variable "cores" {
  description = "CPU cores on the packer builder vm"
  type        = number
  default     = 4
}

variable "disk_size" {
  description = "Disk size on the packer builder vm"
  type        = string
  default     = "50G"
}

variable "distro" {
  description = "Linux distribution"
  type        = string
}

variable "http_directory" {
  description = "Directory for ks server"
  type        = string
}

variable "http_server" {
  description = "HTTP server"
  type        = string
}

variable "is_local" {
  description = "Is http server on your workstation?"
  type        = bool
  default     = true
}

variable "iso_name" {
  description = "ISO name"
  type        = string
}

variable "memory" {
  description = "Memory on the packer builder vm"
  type        = number
  default     = 8192
}

variable "proxmox_node" {
  description = "Proxmox node"
  type        = string
}

variable "proxmox_token" {
  description = "Token for PVE"
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

variable "template_description" {
  description = "Template description"
  type        = string
}

variable "template_name" {
  description = "Template name"
  type        = string
}