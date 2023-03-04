resource kubernetes_namespace argo_rollouts {
  provider = kubernetes.aks-module
  metadata {
    name = "argo-rollouts"
  }
}

# helm repo add argo https://argoproj.github.io/argo-helm
resource helm_release argo_rollouts {
  provider   = helm.aks-module
  name       = "argo-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  version    = "2.20.0" # https://github.com/argoproj/argo-helm/tree/main/charts/argo-rollouts
  namespace  = kubernetes_namespace.argo_rollouts.metadata.0.name

  set {
    name  = "dashboard.enabled"
    value = true
  }
}