# Create the kubecost namespace
resource "kubernetes_namespace" "kubecost" {
  provider = kubernetes.aks-module
  metadata {
    name = "finops"
  }
}

# Install kubecost using the hem chart
resource "helm_release" "kubecost" {
  provider   = helm.aks-module
  name       = "kubecost"
  chart      = "cost-analyzer"
  namespace  = kubernetes_namespace.kubecost.metadata[0].name
  version    = "1.91.2"
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
    value = "true"
  }
}