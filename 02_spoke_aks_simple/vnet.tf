resource "azurerm_virtual_network" "vnet_spoke_aks" {
  name                = "vnet-spoke-aks-simple"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "snet_aks" {
  name                 = "snet-aks"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = ["10.1.1.0/24"]
}

# snet-apiserver
resource "azurerm_subnet" "snet_aks_apiserver" {
  count                = var.enable_apiserver_vnet_integration ? 1 : 0
  name                 = "snet-aks-apiserver"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = ["10.1.2.0/28"]

  delegation {
    name = "aks-apiserver-delegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# resource "azurerm_subnet" "snet_aks_nodepool_apps" {
#   name                 = "snet-aks-apps"
#   virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
#   resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
#   address_prefixes     = ["10.1.2.0/24"]
# }
