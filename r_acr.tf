resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  sku                 = "Standard"
  admin_enabled       = false # true
  tags                = var.tags
}

resource "azurerm_user_assigned_identity" "identity-kubelet" {
  name                = "${var.aks_name}-agentpool"
  resource_group_name = azurerm_resource_group.rg.name # azurerm_kubernetes_cluster.aks.node_resource_group
  location            = var.resources_location
  tags                = var.tags
}

# data "azurerm_user_assigned_identity" "identity-kubelet" {
#   name                = "${azurerm_kubernetes_cluster.aks.name}-agentpool"
#   resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
# }

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.identity-kubelet.principal_id
  skip_service_principal_aad_check = true
}