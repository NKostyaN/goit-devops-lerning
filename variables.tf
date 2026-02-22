variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "goit-lern-nkos-cluster"
}

variable "github_username" {
  description = "GitHub username для Jenkins"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token для Jenkins"
  type        = string
  sensitive   = true # Це приховає значення токена в логах консолі
}

variable "github_repo" {
  description = "GitHub repository URL"
  type = string
  default = "https://github.com/NKostyaN/goit-devops-lerning.git"
}
