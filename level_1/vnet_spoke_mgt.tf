resource "azurerm_virtual_network" "vnet_spoke_mgt" {
  count               = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "vnet-spoke-mgt"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.0.name
  address_space       = var.cidr_vnet_spoke_mgt
  dns_servers         = var.enable_firewall ? [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address] : null
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_mgt" {
  count                = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                 = "subnet-mgt"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.0.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.0.resource_group_name
  address_prefixes     = var.cidr_subnet_mgt
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_mgt" {
  count          = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_mgt.0.id
  route_table_id = azurerm_route_table.route_table_to_firewall.id
}

resource "azurerm_network_security_group" "nsg_subnet_mgt" {
  count               = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "nsg_subnet_mgt"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.0.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_mgt" {
  count                     = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet_mgt.0.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_mgt.0.id
}