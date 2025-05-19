resource "azurerm_route_table" "route_table" {
  name                = "route-table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "route_to_firewall" {
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance" # "VirtualNetworkGateway"
  next_hop_in_ip_address = data.terraform_remote_state.hub.outputs.firewall.private_ip
}

resource "azurerm_subnet_route_table_association" "association_rt_subnet_aks" {
  subnet_id      = azurerm_subnet.snet_aks.id
  route_table_id = azurerm_route_table.route_table.id
}

# resource "azurerm_subnet_route_table_association" "association_rt_subnet_system_pods" {
#   subnet_id      = azurerm_subnet.snet_system_pods.id
#   route_table_id = azurerm_route_table.route_table_to_firewall.id
# }

# resource "azurerm_subnet_route_table_association" "association_rt_subnet_user_nodes" {
#   for_each       = azurerm_subnet.snet_nodes_user_nodepool
#   subnet_id      = each.value.id
#   route_table_id = azurerm_route_table.route_table_to_firewall.id
# }

# resource "azurerm_subnet_route_table_association" "association_rt_subnet_user_pods" {
#   for_each       = azurerm_subnet.snet_pods_user_nodepool
#   subnet_id      = each.value.id
#   route_table_id = azurerm_route_table.route_table_to_firewall.id
# }
