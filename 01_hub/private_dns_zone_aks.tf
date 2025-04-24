resource "azurerm_private_dns_zone" "private_dns_zone_aks" {
  provider            = azurerm.subscription_hub
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_aks_to_vnet_hub" {
  provider              = azurerm.subscription_hub
  name                  = "link_private_dns_zone_acr_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_aks.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_aks.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}
