# resource "azurerm_subnet_route_table_association" "association_route_table_subnet" {
#   subnet_id      = azurerm_subnet.subnet_mgt.0.id
#   route_table_id = azurerm_route_table.route_table_to_firewall.id
# }

resource "azurerm_network_security_group" "nsg_subnet" {
  count               = length(local.subnets)
  name                = "nsg_${local.subnets[count.index].subnet_name}"
  location            = var.resources_location
  resource_group_name = local.subnets[count.index].subnet_rg
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet" {
  count                     = length(local.subnets)
  subnet_id                 = data.azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg_subnet[count.index].id
}