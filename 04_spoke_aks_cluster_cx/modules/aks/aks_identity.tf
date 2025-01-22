resource "azurerm_user_assigned_identity" "identity-aks" {
  name                = "identity-aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "network-contributor" {
  scope                            = var.vnet_aks_id # var.snet_aks_id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "managed-identity-operator" {
  scope                            = azurerm_user_assigned_identity.identity-kubelet.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "contributor" {
  scope                            = var.resource_group_id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "private-dns-zone-contributor" {
  scope                            = var.private_dns_zone_aks_id
  role_definition_name             = "Private DNS Zone Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}
