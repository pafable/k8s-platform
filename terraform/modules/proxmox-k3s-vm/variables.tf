variable "clone_template" {
  description = "Name of clone"
  type        = string
}

variable "cloud_init_pve_node" {
  description = "PVE node to deploy to"
  type        = string
}

variable "cores" {
  description = "Number of cores"
  type        = number
  default     = 2
}

variable "cpu_type" {
  description = "OS cpu type"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "desc" {
  description = "Description"
  type        = string
  default     = "Created and managed by terraform"
}

variable "home_network" {
  description = "Home network"
  type        = string
  default     = "192.168.1.0/24"
}

variable "host_node" {
  description = "Node to host vm"
  type        = string
  default     = "horde"
}

variable "is_SSD" {
  description = "Is drive SSD?"
  type        = string
  default     = true
}

variable "main_disk_size" {
  description = "Main disk size"
  type        = string
  default     = "100G"
}

variable "memory" {
  description = "Memory amount"
  type        = number
  default     = 2048
}

variable "name" {
  description = "VM name"
  type        = string
}

variable "os_type" {
  description = "OS type"
  type        = string
  default     = "Linux 6.x - 2.6 Kernel"
}

variable "runcmd" {
  description = "Command to run on initial instance initialization"
  type        = string
  default     = ""
}

variable "scsihw" {
  description = "SCSI HW type"
  type        = string
  default     = "virtio-scsi-single"
}

variable "ssh_username" {
  description = "ssh_username"
  type        = string
}

variable "storage_location" {
  description = "Storage location"
  type        = string
  default     = "local-lvm"
}

variable "tags" {
  description = "Tags"
  type        = string
  default     = ""
}