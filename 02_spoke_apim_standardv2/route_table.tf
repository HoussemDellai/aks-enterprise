resource "azurerm_route_table" "route_table_to_firewall" {
  name                          = "route-table-to-firewall"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tags                          = var.tags
}

resource "azurerm_route" "route_to_firewall" {
  count                  = var.enable_route_traffic_to_firewall ? 1 : 0
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route_table_to_firewall.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance" # "VirtualNetworkGateway"
  next_hop_in_ip_address = data.terraform_remote_state.hub.0.outputs.firewall.private_ip
}

resource "azurerm_subnet_route_table_association" "association_rt_subnet_apim" {
  subnet_id      = azurerm_subnet.snet-apim.id
  route_table_id = azurerm_route_table.route_table_to_firewall.id
}