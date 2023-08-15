# resource "azurerm_route_table" "route_table" {
#   count                         = var.enable_firewall_as_dns_server ? 1 : 0
#   name                          = "route-table"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
#   disable_bgp_route_propagation = true
#   tags                          = var.tags
# }

# resource "azurerm_route" "route_to_firewall" {
#   # provider               = azurerm.subscription_hub
#   count                  = var.enable_firewall_as_dns_server ? 1 : 0
#   name                   = "route-to-firewall"
#   resource_group_name    = azurerm_route_table.route_table.0.resource_group_name
#   route_table_name       = azurerm_route_table.route_table.0.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance" # "VirtualNetworkGateway"
#   next_hop_in_ip_address = data.terraform_remote_state.hub.0.outputs.firewall.private_ip
# }

resource "azurerm_subnet_route_table_association" "association_rt_subnet_system_nodes" {
  subnet_id      = azurerm_subnet.subnet_system_nodes.id
  route_table_id = data.terraform_remote_state.spoke_aks.outputs.route_table.id
}

resource "azurerm_subnet_route_table_association" "association_rt_subnet_system_pods" {
  subnet_id      = azurerm_subnet.subnet_system_pods.id
  route_table_id = data.terraform_remote_state.spoke_aks.outputs.route_table.id
}

resource "azurerm_subnet_route_table_association" "association_rt_subnet_user_nodes" {
  for_each       = azurerm_subnet.subnet_nodes_user_nodepool
  subnet_id      = each.value.id
  route_table_id = data.terraform_remote_state.spoke_aks.outputs.route_table.id
}

resource "azurerm_subnet_route_table_association" "association_rt_subnet_user_pods" {
  for_each       = azurerm_subnet.subnet_pods_user_nodepool
  subnet_id      = each.value.id
  route_table_id = data.terraform_remote_state.spoke_aks.outputs.route_table.id
}
