variable "argocd_version" {
  description = "ArgoCD helm version"
  type        = string
  default     = "7.3.6"
}

variable "app_repo" {
  description = "ArgoCD app repo"
  type        = string
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "local"
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