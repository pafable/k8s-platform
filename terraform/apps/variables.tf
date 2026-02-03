variable "config_path" {
  description = "Kubernetes config path"
  type        = string
}

variable "config_context" {
  description = "Kubernetes config context"
  type        = string
}

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