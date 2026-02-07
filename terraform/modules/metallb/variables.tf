variable "metallb_version" {
  description = "Metallb version"
  type        = string
  default     = "0.15.3"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops"
}