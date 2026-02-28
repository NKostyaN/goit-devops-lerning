variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  default = "argocd"
}

variable "path_to_charts" {
  description = "Path to cahrts for Argo CD"
  type = string
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_repo" {
  description = "GitHub repository URL"
  type = string
}
