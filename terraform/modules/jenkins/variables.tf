variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform"
}

variable "agent_container_repository" {
  description = "Container repo"
  type        = string
  default     = "jenkins/inbound-agent"
}

variable "agent_container_tag" {
  description = "Container tag"
  type        = string
  default     = "3256.v88a_f6e922152-1"
}

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "5.4.3"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://charts.jenkins.io"
}

variable "ou" {
  description = "Organizational Unit"
  type        = string
  default     = "devops"
}

variable "owner" {
  description = "Owner of resource"
  type        = string
  default     = "devops"
}

variable "timeout" {
  description = "Timeout for the resource"
  type        = number
  default     = 500
}