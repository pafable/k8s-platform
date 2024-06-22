variable "trivy_operator_version" {
  description = "Trivy Operator version"
  type        = string
  default     = "0.23.3"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}