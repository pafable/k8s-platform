variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "81.5.2"
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "home.pafable.com"
}

variable "grafana_image_repo" {
  description = "Grafana image repository"
  type        = string
  default     = "grafana/grafana-enterprise"
}

variable "grafana_image_tag" {
  description = "Grafana image tag"
  type        = string
  default     = "12.4.0-21693836646"
}

# variable "ingress_name" {
#   description = "Ingress to use"
#   type        = string
#   default     = "nginx"
# }

variable "is_cloud" {
  description = "check if the cluster is hosted locally (ie. talos, k3s) or in the cloud"
  type        = bool
  default     = true
}

variable "is_docker_desktop" {
  description = "Checks to see if deploying to docker-desktop"
  type        = bool
  default     = false
}

variable "loki_helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "6.52.0"
}

variable "loki_helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
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