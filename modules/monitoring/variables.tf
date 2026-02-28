variable "namespace" {
  description = "Kubernetes namespace для моніторингу"
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Версія Helm-чарту Prometheus"
  type        = string
  default     = "25.27.0"
}

variable "grafana_chart_version" {
  description = "Версія Helm-чарту Grafana"
  type        = string
  default     = "8.5.0"
}

variable "grafana_admin_password" {
  description = "Пароль адміністратора Grafana"
  type        = string
  sensitive   = true
  default     = "admin123"
}
