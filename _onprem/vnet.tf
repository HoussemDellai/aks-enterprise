resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm.subscription_onprem
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
  tags = var.tags
}

resource "azurerm_subnet" "subnet_onprem_gateway" {
  provider             = azurerm.subscription_onprem
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.255.224/27"]
}

resource "azurerm_subnet" "subnet_onprem_mgmt" {
  provider             = azurerm.subscription_onprem
  name                 = "snet-mgmt"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.128/25"]
}