resource "azurerm_user_assigned_identity" "identity-aks" {
  name                = "identity-aks"
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = var.resources_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_mi_network_contributor" {
  scope                            = azurerm_virtual_network.vnet.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_mi_operator" {
  scope                            = azurerm_user_assigned_identity.identity-kubelet.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_mi_contributor_aks_rg" {
  scope                            = azurerm_resource_group.rg_aks.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

# Assign Network Contributor to the API server subnet
# az role assignment create --scope <apiserver-subnet-resource-id> \
#     --role "Network Contributor" \
#     --assignee <managed-identity-client-id>
resource "azurerm_role_assignment" "aks_mi_network_contributor_apiserver_subnet" {
  count                            = var.enable_apiserver_vnet_integration ? 1 : 0
  scope                            = azurerm_subnet.subnet_apiserver.0.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}