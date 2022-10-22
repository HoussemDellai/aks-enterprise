# Create the kubecost namespace
resource "kubernetes_namespace" "kubecost" {
  provider = kubernetes.aks-module
  metadata {
    name = "finops"
  }
}

# Install kubecost using the hem chart
# https://github.com/kubecost/cost-analyzer-helm-chart/blob/develop/cost-analyzer/
# kubectl create namespace kubecost
# helm repo add kubecost https://kubecost.github.io/cost-analyzer/
# helm install kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="aG91c3NlbS5kZWxsYWlAbGl2ZS5jb20=xm343yadf98"
resource "helm_release" "kubecost" {
  provider   = helm.aks-module
  name       = "kubecost"
  chart      = "cost-analyzer"
  namespace  = kubernetes_namespace.kubecost.metadata.0.name
  version    = "1.96.0"
  repository = "https://kubecost.github.io/cost-analyzer/"

  # Set the cluster name
  set {
    name  = "kubecostProductConfigs.clusterName"
    value = var.aks_name
  }

  # Set the currency
  set {
    name  = "kubecostProductConfigs.currencyCode"
    value = "EUR"
  }

  # Set the region
  set {
    name  = "kubecostProductConfigs.azureBillingRegion"
    value = "NL"
  }

  # Generate a secret based on the Azure configuration provided below
  set {
    name  = "kubecostProductConfigs.createServiceKeySecret"
    value = true
  }

  # Azure Subscription ID
  set {
    name  = "kubecostProductConfigs.azureSubscriptionID"
    value = data.azurerm_subscription.current.subscription_id
  }

  # Azure Client ID
  set {
    name  = "kubecostProductConfigs.azureClientID"
    value = azuread_application.app_kubecost.application_id
  }

  # Azure Client Password
  set {
    name  = "kubecostProductConfigs.azureClientPassword"
    value = azuread_service_principal_password.password_spn_kubecost.value
  }

  # Azure Tenant ID
  set {
    name  = "kubecostProductConfigs.azureTenantID"
    value = data.azurerm_subscription.current.tenant_id
  }

  set {
    name  = "global.prometheus.enabled"
    value = true
  }

  set { # not required
    name  = "kubecostToken"
    value = "aG91c3NlbS5kZWxsYWlAbGl2ZS5jb20=xm343yadf98"
  }
}

# kubectl port-forward --namespace kubecost deployment/kubecost-cost-analyzer 9090
# Access dashboard: http://localhost:9090

# resource "null_resource" "portforward" {
#   provisioner "local-exec" {
#     command = "kubectl port-forward --namespace finops deployment/kubecost-cost-analyzer 9090"
#     interpreter = ["PowerShell", "-Command"]
#   }

# Access dashboard: http://127.0.0.1:8000/k10/#/
#   provisioner "local-exec" {
#     command = "kubectl --namespace kasten-io port-forward service/gateway 8000:8000"
#     interpreter = ["PowerShell", "-Command"]
#   }
# }