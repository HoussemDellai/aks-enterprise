# reference to Azure Kubernetes Service AAD Server app in AAD
data "azuread_service_principal" "aks_aad_server" {
  display_name = "Azure Kubernetes Service AAD Server"
}

# current subscription
data "azurerm_subscription" "current" {}

# current client
data "azuread_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
}

data "azuread_group" "aks_admins" {
  display_name     = var.aad_group_aks_admins
  security_enabled = true
}