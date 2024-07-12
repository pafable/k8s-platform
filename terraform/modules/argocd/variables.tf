variable "argocd_version" {
  description = "ArgoCD helm version"
  type        = string
  default     = "7.3.6"
}

variable "app_repo" {
  description = "ArgoCD app repo"
  type        = string
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