resource azurerm_virtual_network vnet_spoke_appservice {
  #   count               = var.enable_spoke_appservice ? 1 : 0
  name                = "vnet-spoke-appservice"
  location            = azurerm_resource_group.rg_spoke_aksservice.location
  resource_group_name = azurerm_resource_group.rg_spoke_aksservice.name
  address_space       = var.cidr_vnet_spoke_appservice
  dns_servers         = var.enable_firewall ? [data.terraform_remote_state.hub.0.outputs.firewall_private_ip] : null
  tags                = var.tags
}