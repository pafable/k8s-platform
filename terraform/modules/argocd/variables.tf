variable "argocd_version" {
  description = "ArgoCD helm version"
  type        = string
  default     = "9.4.2"
}

variable "app_repo" {
  description = "ArgoCD app repo"
  type        = string
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "home.pafable.com"
}

variable "gateway_class_name" {
  description = "Gateway class name"
  type        = string
  default     = "door"
}

variable "ingress_name" {
  description = "Ingress to use"
  type        = string
  default     = "nginx"
}

variable "ou" {
  description = "The organizational unit"
  type        = string
  default     = "devops"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}