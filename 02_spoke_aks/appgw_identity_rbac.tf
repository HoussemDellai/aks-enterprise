# AppGW (generated with addon) Identity needs also Network Contributor role over AKS/VNET RG
resource "azurerm_role_assignment" "role_appgw_network_contributor" {
  count                = var.enable_app_gateway ? 1 : 0
  scope                = azurerm_virtual_network.vnet_spoke_aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway.0.ingress_application_gateway_identity.0.object_id
}

# AppGW (generated with addon) Identity needs also Contributor role over App Gateway
resource "azurerm_role_assignment" "role_appgw_contributor" {
  count                = var.enable_app_gateway ? 1 : 0
  scope                = azurerm_application_gateway.appgw.0.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway.0.ingress_application_gateway_identity.0.object_id
}

# AppGW (generated with addon) Identity needs also Reder role over App Gateway
resource "azurerm_role_assignment" "role_appgw_reader" {
  count                = var.enable_app_gateway ? 1 : 0
  scope                = azurerm_application_gateway.appgw.0.id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway.0.ingress_application_gateway_identity.0.object_id
}