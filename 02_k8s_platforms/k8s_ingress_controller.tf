resource kubernetes_namespace" "nginx_ingress" {
  provider = kubernetes.aks-module
  metadata {
    name = "ingress"
  }
}

# https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
resource helm_release" "nginx_ingress" {
  provider   = helm.aks-module
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.4.2"
  namespace  = kubernetes_namespace.nginx_ingress.metadata.0.name

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.service.internal.enabled"
    value = "true"
  }
  set {
    name  = "controller.service.internal.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "true"
    type  = "string"
  }
  # set {
  #   name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/use-regex"
  #   value = "true"
  #   type  = "string"
  # }
  set {
    name  = "controller.autoscaling.enabled"
    value = "true"
  }
  set {
    name  = "controller.autoscaling.minReplicas"
    value = "2"
  }
  set {
    name  = "controller.autoscaling.maxReplicas"
    value = "10"
  }
}