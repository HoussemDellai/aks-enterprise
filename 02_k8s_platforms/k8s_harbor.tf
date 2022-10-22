resource "kubernetes_namespace" "harbor" {
  provider = kubernetes.aks-module
  metadata {
    name = "harbor"
  }
}

# https://github.com/goharbor/harbor-helm
resource "helm_release" "harbor" {
  provider   = helm.aks-module
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata.0.name

  set {
    name  = "expose.type"
    value = "clusterIP" # "ingress"
  }
  set { # test
    name  = "expose.tls.enabled"
    value = false
  }
  set {
    name  = "harborAdminPassword"
    value = var.harbor_admin_password
  }
  set {
    name  = "expose.ingress.className"
    value = "nginx"
  }
  set {
    name  = "trace.enabled"
    value = "true"
  }
  set {
    name  = "persistence.enabled"
    value = "true"
  }
  set {
    name  = "clair.enabled"
    value = "true"
  }
  set {
    name  = "notary.enabled"
    value = "true"
  }
  set {
    name  = "trivy.enabled"
    value = "true"
  }
  set {
    name  = "notary.enabled"
    value = "true"
  }
}