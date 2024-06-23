variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "2.7.4"
}

variable "domain_name" {
  description = "The domain name for the Kong Mesh UI"
  type        = string
  default     = "kong-mesh.local"
}

variable "is_ingress_enabled" {
  description = "Enable Ingress for Kong Mesh UI"
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

variable "namespace" {
  description = "The namespace to install the Helm chart"
  type        = string
  default     = "kong-mesh"
}