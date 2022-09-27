# https://www.kasten.io/kubernetes/resources/videos/-kubernetes-backup-and-restore-made-easy
resource "kubernetes_namespace" "kasten" {
  provider = kubernetes.aks-module
  metadata {
    name = "kasten-io"
  }
}

# helm install k10 kasten/k10 --namespace="kasten-io" `
#  --set secrets.azureTenantId="558506eb-9459-4ef3-b920-ad55c555e729" `
#  --set secrets.azureClientId="d56eec9e-d2f2-4ff5-a8d8-6795d3557b39" `
#  --set secrets.azureClientSecret="aHg8Q~5jDUgSTUFcPoX9lQ2Hwr5EmCoY1hCobaWD" `
#  --set services.dashboardbff.hostNetwork=true
resource "helm_release" "kasten" {
  provider   = helm.aks-module
  name       = "k10"
  repository = "https://charts.kasten.io/"
  chart      = "k10"
  namespace  = kubernetes_namespace.kasten.metadata.0.name

  set {
    name  = "secrets.azureTenantId"
    value = data.azurerm_subscription.current.tenant_id
  }
  set {
    name  = "secrets.azureClientId"
    value = azuread_application.app_kasten.application_id
  }
  set {
    name  = "secrets.azureClientSecret"
    value = azuread_service_principal_password.password_spn_kasten.value
  }
  set {
    name  = "services.dashboardbff.hostNetwork"
    value = true
  }
}

# kubectl --namespace kasten-io port-forward service/gateway 8000:8000
# Access dashboard: http://127.0.0.1:8000/k10/#/

# resource "kubernetes_service" "kasten_gateway_lb" {
#   metadata {
#     name = "gatewaylb"
#     namespace = kubernetes_namespace.kasten.metadata[0].name
#   }
#   spec {
#     selector = {
#       service = "gateway"
#       component = "gateway"
#     }
#     port {
#       port        = 8080
#       target_port = 8000
#     }

#     type = "LoadBalancer"
#   }
# }