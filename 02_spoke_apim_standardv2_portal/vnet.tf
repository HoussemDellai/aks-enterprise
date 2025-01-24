resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-spoke-apim-portal"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.3.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-ai" {
  name                 = "snet-ai"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.3.0.0/24"]
}

resource "azurerm_subnet" "snet-apim" {
  name                 = "snet-apim"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.3.1.0/24"]
  
#   service_endpoints    = ["Microsoft.Web"]

  delegation {
    name = "Microsoft.Web/serverFarms"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "snet-jumpbox" {
  name                 = "snet-jumpbox"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.3.2.0/24"]
}

resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.3.3.0/24"]
}
