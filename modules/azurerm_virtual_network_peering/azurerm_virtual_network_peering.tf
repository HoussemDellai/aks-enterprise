resource "azurerm_virtual_network_peering" "vnet_peering_hub_to_spoke" {
#   provider                     = azurerm.subscription_hub
  name                         = "vnet_peering_hub_to_${local.vnet_spoke_name}"
  virtual_network_name         = local.vnet_hub_name
  resource_group_name          = local.vnet_hub_rg
  remote_virtual_network_id    = var.vnet_spoke_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "vnet_peering_spoke_to_hub" {
  name                         = "vnet_peering_${local.vnet_spoke_name}_to_hub"
  virtual_network_name         = local.vnet_spoke_name
  resource_group_name          = local.vnet_spoke_rg
  remote_virtual_network_id    = var.vnet_hub_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

locals {
    vnet_hub_name = split("/", var.vnet_hub_id)[8]
    vnet_hub_rg = split("/", var.vnet_hub_id)[4]
    vnet_spoke_name = split("/", var.vnet_spoke_id)[8]
    vnet_spoke_rg = split("/", var.vnet_spoke_id)[4]
}