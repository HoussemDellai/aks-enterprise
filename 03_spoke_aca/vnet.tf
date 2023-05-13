resource "azurerm_virtual_network" "vnet_spoke_aca" {
  #   count               = var.enable_spoke_appservice ? 1 : 0
  name                = "vnet-spoke-aca"
  location            = azurerm_resource_group.rg_spoke_aca.location
  resource_group_name = azurerm_resource_group.rg_spoke_aca.name
  address_space       = ["10.100.0.0/23"] # var.cidr_vnet_spoke_aca #todo
  dns_servers         = var.enable_firewall ? [data.terraform_remote_state.hub.0.outputs.firewall_private_ip] : null
  tags                = var.tags
}