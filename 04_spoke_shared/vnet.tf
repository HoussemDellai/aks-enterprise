resource azurerm_virtual_network" "vnet_spoke_shared" {
  name                = "vnet-spoke-shared"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_shared.name
  address_space       = var.cidr_vnet_spoke_shared
  dns_servers         = var.enable_firewall ? [data.terraform_remote_state.hub.0.outputs.firewall_private_ip] : null
  tags                = var.tags
}

module "virtual_network_peering_hub_and_spoke_shared" {
  count         = var.enable_vnet_peering && var.enable_mysql_flexible_server ? 1 : 0
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = data.terraform_remote_state.hub.0.outputs.vnet_hub_id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke_shared.0.id
}