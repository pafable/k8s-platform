variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform"
}

variable "aws_dev_deployer_access_key" {
  description = "AWS dev access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_dev_deployer_secret_key" {
  description = "AWS dev secret key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "agent_container_repository" {
  description = "Container repo"
  type        = string
  default     = "jenkins/inbound-agent"
}

variable "agent_container_tag" {
  description = "Container tag"
  type        = string
  default     = "3261.v9c670a_4748a_9-1"
}

variable "docker_hub_username" {
  description = "Username for docker hub"
  type        = string
  default     = ""
}

variable "docker_hub_password" {
  description = "Password for docker hub"
  type        = string
  default     = ""
  sensitive   = true
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

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "Etc/UTC"
}