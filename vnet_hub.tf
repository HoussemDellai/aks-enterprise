# VNET Hub in a HUB Subscription
resource "azurerm_virtual_network" "vnet_hub" {
  provider            = azurerm.subscription_hub
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.resources_location
  address_space       = var.cidr_vnet_hub
  tags                = var.tags
}

# Subnet for Azure Firewall, without NSG as per Firewall requirements
resource "azurerm_subnet" "subnet_firewall" {
  count                                     = var.enable_firewall ? 1 : 0
  provider                                  = azurerm.subscription_hub
  name                                      = "AzureFirewallSubnet"
  resource_group_name                       = azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = var.cidr_subnet_firewall
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "subnet_bastion" {
  count                = var.enable_bastion ? 1 : 0
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  resource_group_name  = azurerm_virtual_network.vnet_hub.resource_group_name
  address_prefixes     = var.cidr_subnet_bastion
}

# module "diagnostic_setting_vnet_hub" {
#   count                      = var.enable_monitoring ? 1 : 0
#   source                     = "./modules/diagnostic_setting"
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
#   target_resource_id         = azurerm_virtual_network.vnet_hub.id
# }

# output "monitor_diagnostic_categories_vnet_hub" {
#   value = module.diagnostic_setting_vnet_hub.0.monitor_diagnostic_categories
# }
