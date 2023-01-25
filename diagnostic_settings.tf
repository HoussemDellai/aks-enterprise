# # Get resources by type
# data "azurerm_resources" "subnets" {
#   type = "Microsoft.Network/virtualNetworks/subnets"
#   required_tags = var.tags
# }

# resource "azurerm_network_security_group" "nsg" {
#   count               = length(data.azurerm_resources.subnets.resources)
#   name                = "nsg_subnet_vnet_integration"
#   location            = var.resources_location
#   resource_group_name = data.azurerm_resources.subnets.resources[count.index]. # azurerm_resource_group.rg_spoke3.0.name
#   tags                = var.tags
# }

# Get resources by type
data "azurerm_resources" "nsg" {
  type          = "Microsoft.Network/networkSecurityGroups"
  required_tags = var.tags
}

module "diagnostic_setting_nsg" {
  count                      = var.enable_monitoring ? length(data.azurerm_resources.nsg.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.nsg.resources[count.index].id
}

output "monitor_diagnostic_categories_nsg" {
  value = var.enable_monitoring ? module.diagnostic_setting_nsg.*.monitor_diagnostic_categories : null
}

data "azurerm_resources" "vnet" {
  type          = "Microsoft.Network/virtualNetworks"
  required_tags = var.tags
}

module "diagnostic_setting_vnet" {
  count                      = var.enable_monitoring ? length(data.azurerm_resources.vnet.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.vnet.resources[count.index].id
}

output "monitor_diagnostic_categories_vnet" {
  value = var.enable_monitoring ? module.diagnostic_setting_vnet.*.monitor_diagnostic_categories : null
}

# # Get resources by type, create spoke vNet peerings
# data "azurerm_resources" "spokes" {
#   type = "Microsoft.Network/virtualNetworks"

#   required_tags = {
#     environment = "production"
#     role        = "spokeNetwork"
#   }
# }