variable "iso" {
  description = "ISO"
  type        = string
  default     = "local:iso/talos-linux-v1-14-2-metal-amd64.iso"
}

variable "node" {
  description = "Node name"
  type        = string
  default     = "behemoth"
}