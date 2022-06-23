resource "kubernetes_namespace" "argo_cd" {
  provider = kubernetes.aks-module
  metadata {
    name = "gitops"
  }
}

resource "helm_release" "argo_cd" {
  provider   = helm.aks-module
  name       = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.8.2"
  namespace  = kubernetes_namespace.argo_cd.metadata[0].name

  # annotations:
  #   nginx.ingress.kubernetes.io/ssl-redirect: "false"
  #   nginx.ingress.kubernetes.io/use-regex: "true"
  #   nginx.ingress.kubernetes.io/rewrite-target: /$1
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "false"
    type  = "string"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/use-regex"
    value = "true"
    type  = "string"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
    value = "/$1"
  }
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.https"
    value = "true"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.pathType"
    value = "Prefix"
  }
  set {
    name  = "server.ingress.paths"
    value = "{/argocd(.*)}" # "[\"/argocd\"]"
  }
}