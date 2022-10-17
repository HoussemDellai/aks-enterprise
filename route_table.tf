resource "azurerm_route_table" "route_table_to_firewall" {
  count                         = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                          = "route_table_subnet_mgt"
  location                      = var.resources_location
  resource_group_name           = azurerm_resource_group.rg_spoke_mgt.0.name
  disable_bgp_route_propagation = false

  route {
    name                   = "route_to_firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address
  }
}