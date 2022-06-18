# reference to Azure Kubernetes Service AAD Server app in AAD
data "azuread_service_principal" "aks_aad_server" {
  display_name = "Azure Kubernetes Service AAD Server"
}

# current subscription
data "azurerm_subscription" "current" {}

# current client
data "azuread_client_config" "current" {}

# retrieve the versions of Kubernetes supported by AKS
data "azurerm_kubernetes_service_versions" "current" {
  location = var.resources_location
}

# data "azurerm_kubernetes_cluster" "aks_cluster" {
#   name                = var.aks_name
#   resource_group_name = azurerm_resource_group.rg.name

#   depends_on          = [azurerm_kubernetes_cluster.aks]
# }