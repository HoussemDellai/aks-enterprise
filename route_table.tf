resource "azurerm_route_table" "route_table_to_firewall" {
  count                         = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                          = "route_table_subnet_mgt"
  location                      = var.resources_location
  resource_group_name           = azurerm_resource_group.rg_spoke_mgt.0.name
  disable_bgp_route_propagation = true

  route {
    name                   = "route_to_firewall"
    address_prefix         = "0.0.0.0/0" # destination
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address
  }

  route {
    name                   = "route_to_internet"
    address_prefix         = "${azurerm_public_ip.public_ip_firewall.0.ip_address}/32" # destination
    next_hop_type          = "Internet"
    # next_hop_in_ip_address = ""
  }
}