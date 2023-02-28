resource kubernetes_namespace" "keda" {
  provider = kubernetes.aks-module
  metadata {
    name = "keda"
  }
}

# https://github.com/kedacore/charts
resource helm_release" "keda" {
  provider   = helm.aks-module
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.7.2"
  namespace  = kubernetes_namespace.keda.metadata.0.name
}