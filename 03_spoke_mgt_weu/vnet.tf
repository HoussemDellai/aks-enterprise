resource "azurerm_virtual_network" "vnet_spoke_mgt" {
  name                = "vnet-${var.prefix}-spoke-mgt"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.cidr_vnet_spoke_mgt
  dns_servers         = var.enable_firewall ? [data.terraform_remote_state.hub.0.outputs.firewall.private_ip] : null
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_vm" {
  name                 = "subnet-vm"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.resource_group_name
  address_prefixes     = var.cidr_subnet_mgt
}

module "virtual_network_peering_hub_and_spoke_mgt" {
  count         = var.enable_vnet_peering ? 1 : 0
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = data.terraform_remote_state.hub.0.outputs.vnet_hub.id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke_mgt.id
}