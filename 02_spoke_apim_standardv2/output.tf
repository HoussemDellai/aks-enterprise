output "vnet_spoke_apim" {
  value = {
    virtual_network_name = azurerm_virtual_network.vnet-spoke.name
    resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
    id                   = azurerm_virtual_network.vnet-spoke.id
    address_space        = azurerm_virtual_network.vnet-spoke.address_space
  }
}

output "snet_apim" {
  value = {
    id = azurerm_subnet.snet-apim.id
  }
}

output "route_table" {
  value = {
    id = azurerm_route_table.route_table_to_firewall.id
  }
}
