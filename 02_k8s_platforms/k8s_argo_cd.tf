resource kubernetes_namespace argo_cd {
  provider = kubernetes.aks-module
  metadata {
    name = "gitops"
  }
}

# helm repo add argo https://argoproj.github.io/argo-helm
resource helm_release argo_cd {
  provider   = helm.aks-module
  name       = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.4.2" # "4.8.2" https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/Chart.yaml
  namespace  = kubernetes_namespace.argo_cd.metadata.0.name

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }
}