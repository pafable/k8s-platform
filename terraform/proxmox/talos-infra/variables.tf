variable "iso" {
  description = "ISO"
  type        = string
  default     = "local:iso/talos-linux-qemu-metal-amd64.iso"
}

variable "node" {
  description = "Node name"
  type        = string
  default     = "leviathan"
}