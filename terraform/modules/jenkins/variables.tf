variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform"
}

variable "domain" {
  description = "Domain"
  type        = string
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
  default     = "3273.v4cfe589b_fd83-1"
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

variable "ingress_name" {
  description = "Ingress to use"
  type        = string
  default     = "nginx"
}

variable "jenkins_github_token" {
  description = "Github token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "k3s_config_file" {
  description = "K3S kubeconfig file"
  type        = string
  default     = ""
  sensitive   = true
}

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "5.7.11"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://charts.jenkins.io"
}

variable "http_server" {
  description = "http server"
  type        = string
  default     = "localhost"
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

variable "packer_ssh_password" {
  description = "Packer ssh password"
  type        = string
  sensitive   = true
}

variable "packer_ssh_username" {
  description = "Packer ssh username"
  type        = string
  sensitive   = true
}

variable "proxmox_token_id" {
  description = "Proxmox token id"
  type        = string
  default     = ""
}

variable "proxmox_token_secret" {
  description = "Proxmox token secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "secrets_manager_region" {
  description = "Secrets AWS region"
  type        = string
  default     = "us-east-1"
}

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
  default     = "local-path"
}

variable "timeout" {
  description = "Timeout for the resource"
  type        = number
  default     = 300
}

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "Etc/UTC"
}

variable "cert" {
  description = "Certificate"
  type        = string
  sensitive   = true
}

variable "cert_private_key" {
  description = "Certificate private key"
  type        = string
  sensitive   = true
}