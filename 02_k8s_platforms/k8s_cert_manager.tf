resource "kubernetes_namespace" "cert_manager" {
  provider = kubernetes.aks-module
  metadata {
    name = "cert-manager"
  }
}

# https://github.com/goharbor/harbor-helm
resource "helm_release" "cert_manager" {
  provider   = helm.aks-module
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
}