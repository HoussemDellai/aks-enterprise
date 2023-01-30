# VNET Hub in a HUB Subscription
resource "azurerm_virtual_network" "vnet_hub" {
  provider            = azurerm.subscription_hub
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.resources_location
  address_space       = var.cidr_vnet_hub
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet_spoke3" {
  count               = var.enable_spoke_3 ? 1 : 0
  name                = "vnet_spoke3"
  location            = azurerm_resource_group.rg_spoke3.0.location
  resource_group_name = azurerm_resource_group.rg_spoke3.0.name
  address_space       = var.cidr_vnet_spoke_3
  dns_servers         = var.enable_firewall ? [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address] : null
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet_spoke_shared" {
  name                = "vnet-spoke-shared"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_shared.name
  address_space       = var.cidr_vnet_spoke_shared
  dns_servers         = var.enable_firewall ? [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address] : null
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet_spoke_app" {
  name                = "vnet-spoke-app"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_app.name
  address_space       = var.cidr_vnet_spoke_app
  dns_servers         = var.enable_firewall ? [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address] : null
  tags                = var.tags
}