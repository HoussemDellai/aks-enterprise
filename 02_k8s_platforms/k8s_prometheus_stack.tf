resource kubernetes_namespace" "prometheus_stack" {
  provider = kubernetes.aks-module
  metadata {
    name = "monitoring"
  }
}

# output "prometheus_stack_values" {
#   value = helm_release.prometheus_stack.manifest.values
# }

output "prometheus_stack_manifest" {
  value = helm_release.prometheus_stack.manifest
}

# https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
resource helm_release" "prometheus_stack" {
  provider   = helm.aks-module
  name       = "prom"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.prometheus_stack.metadata.0.name
  timeout    = 300 # 180 # 

  set {
    name  = "grafana.adminUser"
    value = var.grafana_admin_user
  }
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  #   set {
  #     name  = "grafana.ingress.enabled"
  #     value = "true"
  #   }
  #   set {
  #     name  = "grafana.ingress.ingressClassName"
  #     value = "nginx"
  #   }
  #   set {
  #     name  = "grafana.ingress.path"
  #     value = "/(.*)" # "/grafana2/?(.*)"
  #   }
  #   # annotations:
  #   #   nginx.ingress.kubernetes.io/ssl-redirect: "false"
  #   #   nginx.ingress.kubernetes.io/use-regex: "true"
  #   #   nginx.ingress.kubernetes.io/rewrite-target: /$1
  #   set {
  #     name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
  #     value = "false"
  #     type  = "string"
  #   }
  #   set {
  #     name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/use-regex"
  #     value = "true"
  #     type  = "string"
  #   }
  #   set {
  #     name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
  #     value = "/$1"
  #   }
}

# resource kubernetes_service_v1" "prometheus_stack" {
#   metadata {
#     name = "prom-grafana-public"
#     namespace = kubernetes_namespace.prometheus_stack.metadata.0.name
#   }

#   spec {
#     selector = {
#       "app.kubernetes.io/instance" = "prom"
#       "app.kubernetes.io/name" = "grafana"
#     }

#     port {
#       port        = 8080
#       target_port = 3000
#     }

#     type = "LoadBalancer"
#   }
# }