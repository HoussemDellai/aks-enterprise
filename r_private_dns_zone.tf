# Deploy DNS Private Zone for AKS
resource "azurerm_private_dns_zone" "private_dns_aks" {
  count               = var.enable_private_cluster ? 1 : 0
  name                = "privatelink.westeurope.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg.name
}

# Needed for Jumpbox to resolve cluster URL using a private endpoint and private dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_aks_vnet_vm_devbox" {
  count                 = var.enable_private_cluster ? 1 : 0
  name                  = "link_private_dns_aks_vnet_vm_devbox"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_aks.0.name
  virtual_network_id    = data.azurerm_virtual_network.vnet_vm_jumpbox.0.id
}

resource "azurerm_role_assignment" "aks_contributor_dns" {
  count                = var.enable_private_cluster ? 1 : 0
  scope                = azurerm_private_dns_zone.private_dns_aks.0.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.identity-aks.principal_id
}