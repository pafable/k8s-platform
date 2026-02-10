variable "app_name" {
  description = "App name"
  type        = string
  default     = "kube-prometheus-stack"
}

variable "chart_repo" {
  description = "Chart repo"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "chart_version" {
  description = "Chart version"
  type        = string
  default     = "81.6.1"
}

variable "cluster_issuer" {
  description = "Cluster Issuer"
  type        = string
  default     = "self-signed-ca-cluster-issuer"
}

variable "domain" {
  description = "Domain"
  type        = string
}

variable "gateway_class_name" {
  description = "Gateway class name"
  type        = string
  default     = "door"
}

variable "is_talos" {
  description = "Is the k8s cluster being deployed to talos"
  type        = bool
  default     = true
}

variable "ou" {
  description = "Organizational unit"
  type        = string
  default     = "devops"
}

variable "owner" {
  description = "Owner"
  type        = string
  default     = "devops"
}