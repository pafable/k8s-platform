variable "clone_template" {
  description = "Name of clone"
  type        = string
  default     = ""
}

variable "cores" {
  description = "Number of cores"
  type        = number
  default     = 4
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

variable "host_node" {
  description = "Node to host vm"
  type        = string
}

variable "is_SSD" {
  description = "Is drive SSD?"
  type        = string
  default     = true
}

variable "iso" {
  description = "ISO to use"
  type        = string
  default     = ""
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

variable "scsihw" {
  description = "SCSI HW type"
  type        = string
  default     = "virtio-scsi-single"
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

variable "user_data" {
  description = "User data for cloud-init"
  type        = string
  default     = ""
}