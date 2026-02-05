variable "metallb_version" {
  description = "Metallb version"
  type        = string
  default     = "v0.15.3"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops"
}