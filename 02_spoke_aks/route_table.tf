resource azurerm_subnet_route_table_association" "association_route_table_subnet_nodes" {
  count          = var.enable_hub_spoke ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_nodes.id
  route_table_id = data.terraform_remote_state.hub.0.outputs.route_table_id # azurerm_route_table.route_table_to_firewall.id
}

resource azurerm_subnet_route_table_association" "association_route_table_subnet_pods" {
  count          = var.enable_hub_spoke ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_nodes.id
  route_table_id = data.terraform_remote_state.hub.0.outputs.route_table_id # azurerm_route_table.route_table_to_firewall.id
}

#todo: add other subnets RT associations