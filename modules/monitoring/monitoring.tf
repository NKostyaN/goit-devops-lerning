# Namespace для моніторингу
resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# Prometheus
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_chart_version
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name

  values = [file("${path.module}/values_prometheus.yaml")]

  depends_on = [kubernetes_namespace_v1.monitoring]
}

# Grafana
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_chart_version
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name

  values = [
    templatefile("${path.module}/values_grafana.yaml", {
      grafana_admin_password = var.grafana_admin_password
    })
  ]

  depends_on = [helm_release.prometheus]
}
