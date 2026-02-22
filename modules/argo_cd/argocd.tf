# Встановлення самого Argo CD
resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

# Встановлення "Bootstrap" чарта (App of Apps)
resource "helm_release" "argo_apps" {
  name       = "argo-cd-apps"
  chart      = "${path.module}/charts"
  namespace  = var.namespace
  create_namespace = false

  depends_on = [helm_release.argo_cd]

    values = [
    templatefile("${path.module}/charts/values.yaml", {
      github_username = var.github_username
      github_token    = var.github_token
      github_repo     = var.github_repo
    })
  ]
}

