resource "azurerm_route_table" "route_table_to_firewall" {
  # provider                      = azurerm.subscription_spoke
  count                         = var.enable_firewall_as_dns_server ? 1 : 0
  name                          = "route-table-to-firewall"
  location                      = var.resources_location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = true
  tags                          = var.tags
}

resource "azurerm_route" "route_to_firewall" {
  # provider               = azurerm.subscription_spoke
  count                  = var.enable_firewall_as_dns_server ? 1 : 0
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route_table_to_firewall.0.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.terraform_remote_state.hub.0.outputs.firewall.private_ip
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet" {
  count          = var.enable_firewall_as_dns_server ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_vm.id
  route_table_id = azurerm_route_table.route_table_to_firewall.0.id
}
