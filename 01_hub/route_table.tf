resource "azurerm_route_table" "route_table_to_firewall" {
  provider            = azurerm.subscription_hub
  name                = "route-table-to-firewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_route" "route_to_firewall" {
  provider               = azurerm.subscription_hub
  count                  = var.enable_firewall ? 1 : 0
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route_table_to_firewall.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance" # "VirtualNetworkGateway"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

# resource azurerm_route force_internet_tunneling {
#   name                = "InternetForceTunneling"
#   resource_group_name = var.resource_group_name
#   route_table_name    = azurerm_route_table.route_table.name
#   address_prefix      = "0.0.0.0/0"
#   next_hop_type       = "VirtualNetworkGateway"
# }
