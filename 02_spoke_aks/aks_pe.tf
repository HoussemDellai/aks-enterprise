# Deploy DNS Private Zone for AKS
resource "azurerm_private_dns_zone" "private_dns_zone_aks" {
  count               = var.enable_private_cluster ? 1 : 0
  name                = "privatelink.${var.resources_location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "role_private_dns_zone_aks_contributor" {
  count                = var.enable_private_cluster ? 1 : 0
  scope                = azurerm_private_dns_zone.private_dns_zone_aks.0.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.identity_aks.principal_id
}

# Needed for Jumpbox to resolve cluster URL using a private endpoint and private dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_aks_to_vnet_hub" {
  count                 = var.enable_vnet_peering && var.enable_private_cluster ? 1 : 0
  name                  = "link_private_dns_zone_aks_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_aks.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_aks.0.name
  virtual_network_id    = data.terraform_remote_state.hub.outputs.vnet_hub_id # azurerm_virtual_network.vnet_hub.0.id
}