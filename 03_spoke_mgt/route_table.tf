resource azurerm_subnet_route_table_association" "association_route_table_subnet_mgt" {
  count          = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_mgt.id
  route_table_id = data.terraform_remote_state.hub.0.outputs.route_table_id # azurerm_route_table.route_table_to_firewall.id
}