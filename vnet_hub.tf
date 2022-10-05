# VNET Hub in a HUB Subscription
resource "azurerm_virtual_network" "vnet_hub" {
  count               = var.enable_vnet_peering ? 1 : 0
  provider            = azurerm.subscription_hub
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.resources_location
  address_space       = var.cidr_vnet_hub
}
# data "azurerm_virtual_network" "vnet_hub" {
#   count               = var.enable_vnet_peering ? 1 : 0
#   provider            = azurerm.subscription_hub
#   name                = "rg-vm-devbox-vnet"
#   resource_group_name = "rg-vm-devbox"
# }

# Firewall Subnet
# (Additional subnet for Azure Firewall, without NSG as per Firewall requirements)
resource "azurerm_subnet" "subnet_firewall" {
  count                                     = var.enable_firewall ? 1 : 0
  provider                                  = azurerm.subscription_hub
  name                                      = "AzureFirewallSubnet"
  resource_group_name                       = azurerm_virtual_network.vnet_hub.0.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.0.name
  address_prefixes                          = var.cidr_subnet_firewall
  private_endpoint_network_policies_enabled = false
}