resource "azurerm_virtual_network" "vnet_spoke_shared" {
  name                = "vnet-spoke-shared"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_shared.name
  address_space       = var.cidr_vnet_spoke_shared
  dns_servers         = [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address]
  tags                = var.tags
}