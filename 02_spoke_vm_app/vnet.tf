resource "azurerm_virtual_network" "vnet_spoke" {
  name                = "vnet-spoke-vm-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.99.0.0/16"]
}

resource "azurerm_subnet" "subnet_vm" {
  name                 = "snet-vm"
  resource_group_name  = azurerm_virtual_network.vnet_spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke.name
  address_prefixes     = ["10.99.1.0/24"]
}