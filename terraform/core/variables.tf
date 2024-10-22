variable "domain" {
  description = "Domain"
  type        = string
  default     = "home.pafable.com"
}

variable "ingress" {
  description = "Ingress to use"
  type        = string
  default     = "nginx"
}