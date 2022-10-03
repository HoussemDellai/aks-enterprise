# Deploy DNS Private Zone for AKS
resource "azurerm_private_dns_zone" "private_dns_aks" {
  count               = var.enable_private_cluster ? 1 : 0
  name                = "privatelink.westeurope.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg_aks.name
}

resource "azurerm_role_assignment" "aks_contributor_dns" {
  count                = var.enable_private_cluster ? 1 : 0
  scope                = azurerm_private_dns_zone.private_dns_aks.0.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.identity-aks.principal_id
}