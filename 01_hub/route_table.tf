resource "azurerm_route_table" "route_table_to_firewall" {
  # count                         = var.enable_firewall ? 1 : 0
  name                          = "route-table-to-firewall"
  location                      = var.resources_location
  resource_group_name           = azurerm_resource_group.rg_hub.name
  disable_bgp_route_propagation = true
  tags                          = var.tags

  # dynamic "route" {
  #   for_each = var.enable_firewall ? ["any_value"] : []
  #   content {
  #     name                   = "route-to-firewall"
  #     address_prefix         = "0.0.0.0/0"
  #     next_hop_type          = "VirtualAppliance"
  #     next_hop_in_ip_address = azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address
  #   }
  # }
  # route {
  #   name           = "route_to_internet"
  #   address_prefix = "${azurerm_public_ip.public_ip_firewall.0.ip_address}/32"
  #   next_hop_type  = "Internet"
  #   # next_hop_in_ip_address = "" # null
  # }
}

resource "azurerm_route" "route_to_firewall" {
  # count                  = var.enable_firewall ? 1 : 0
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.rg_hub.name
  route_table_name       = azurerm_route_table.route_table_to_firewall.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance" # "VirtualNetworkGateway"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

# resource "azurerm_route" "force_internet_tunneling" {
#   name                = "InternetForceTunneling"
#   resource_group_name = var.resource_group_name
#   route_table_name    = azurerm_route_table.route_table.name
#   address_prefix      = "0.0.0.0/0"
#   next_hop_type       = "VirtualNetworkGateway"
# }

output route_table_id {
  value = azurerm_route_table.route_table_to_firewall.id
}