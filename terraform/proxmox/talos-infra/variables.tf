variable "iso" {
  description = "ISO"
  type        = string
  default     = "local:iso/talos-linux-qemu-metal-amd64.iso"
}

variable "leviathan_node" {
  description = "Leviathan node name"
  type        = string
  default     = "leviathan"
}