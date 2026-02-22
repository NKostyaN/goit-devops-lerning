variable "ecr_name" {
  description = "Назва ECR-репозиторію"
  type        = string
}

variable "scan_on_push" {
  description = "Чи сканувати автоматично?"
  type        = bool
  default     = true
}
