resource "azurerm_virtual_network" "vnet_spoke_aks" {
  name                = "vnet-spoke-aks"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.cidr_vnet_spoke_aks
  dns_servers         = var.enable_hub_spoke && var.enable_firewall_as_dns_server ? [data.terraform_remote_state.hub.0.outputs.firewall.private_ip] : null
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_pe" {
  count                = var.enable_private_acr || var.enable_private_keyvault ? 1 : 0
  name                 = "subnet-pe"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_spoke_aks_pe
}

resource "azurerm_subnet" "subnet_agc" {
  count                = var.enable_appgateway_containers ? 1 : 0
  name                 = "subnet-agc"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = ["10.1.200.0/24"] # todo
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.ServiceNetworking/trafficControllers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
