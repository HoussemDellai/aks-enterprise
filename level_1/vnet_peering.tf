#-----------------------------------------------------------------------------------------------------------------#
#   VNET PEERINGS
#   https://medium.com/microsoftazure/configure-azure-virtual-network-peerings-with-terraform-762b708a28d4                                                                       #
#-----------------------------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network_peering" "vnet_peering_hub_to_spoke" {
  count                        = var.enable_vnet_peering ? 1 : 0
  provider                     = azurerm.subscription_hub
  name                         = "vnet_peering_hub_to_spoke"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_app.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet_peering_spoke_to_hub" {
  count                        = var.enable_vnet_peering ? 1 : 0
  name                         = "vnet_peering_spoke_to_hub"
  virtual_network_name         = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name          = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet_peering_hub_to_spoke_mgt" {
  count                        = var.enable_vnet_peering ? 1 : 0
  provider                     = azurerm.subscription_hub
  name                         = "vnet_peering_hub_to_spoke_mgt"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_mgt.0.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet_peering_spoke_mgt_to_hub" {
  count                        = var.enable_vnet_peering ? 1 : 0
  name                         = "vnet_peering_spoke_mgt_to_hub"
  virtual_network_name         = azurerm_virtual_network.vnet_spoke_mgt.0.name
  resource_group_name          = azurerm_virtual_network.vnet_spoke_mgt.0.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet_peering_hub_to_spoke3" {
  count                        = var.enable_vnet_peering ? 1 : 0
  provider                     = azurerm.subscription_hub
  name                         = "vnet_peering_hub_to_spoke3"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke3.0.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet_peering_spoke3_to_hub" {
  count                        = var.enable_vnet_peering ? 1 : 0
  name                         = "vnet_peering_spoke3_to_hub"
  virtual_network_name         = azurerm_virtual_network.vnet_spoke3.0.name
  resource_group_name          = azurerm_virtual_network.vnet_spoke3.0.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}


# Needed for Jumpbox to resolve cluster URL using a private endpoint and private dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_aks_to_vnet_hub" {
  count                 = var.enable_vnet_peering && var.enable_private_cluster ? 1 : 0
  name                  = "link_private_dns_zone_aks_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_aks.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_aks.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_acr_to_vnet_hub" {
  count                 = var.enable_vnet_peering && var.enable_private_acr ? 1 : 0
  name                  = "link_private_dns_zone_acr_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_acr.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_acr.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_keyvault_to_vnet_hub" {
  count                 = var.enable_vnet_peering && var.enable_private_keyvault && var.enable_keyvault ? 1 : 0
  name                  = "link_private_dns_zone_keyvault_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_keyvault.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_keyvault.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}