resource "azurerm_virtual_network" "vnet_hub" {
  provider            = azurerm.subscription_hub
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.resources_location
  address_space       = var.cidr_vnet_hub
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_vm" {
  count                                     = var.enable_firewall ? 1 : 0
  provider                                  = azurerm.subscription_hub
  name                                      = "subnet-vm"
  resource_group_name                       = azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = var.cidr_subnet_vm
  private_endpoint_network_policies_enabled = false
}