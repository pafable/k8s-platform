variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "2.6.3"
}

# https://chaos-mesh.org/docs/production-installation-using-helm/#step-4-install-chaos-mesh-in-different-environments
variable "container_runtime" {
  description = "The container runtime to use. i.e. docker, containerd, k3s"
  type        = string
  default     = "docker"
}

variable "ingress_name" {
  description = "Ingress to use"
  type        = string
  default     = "nginx"
}

variable "is_dashboard_security_enabled" {
  description = "Enable dashboard security"
  type        = bool
  default     = true
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