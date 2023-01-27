# https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/bastion_host.tf
resource "azurerm_public_ip" "public_ip_bastion" {
  provider            = azurerm.subscription_hub
  count               = var.enable_bastion ? 1 : 0
  name                = "public-ip-bastion"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name #var.rg_spoke
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_host" {
  provider               = azurerm.subscription_hub
  count                  = var.enable_bastion ? 1 : 0
  name                   = "bastion-host"
  location               = var.resources_location
  resource_group_name    = azurerm_resource_group.rg_hub.name
  sku                    = "Standard"
  scale_units            = 2 # between 2 and 50
  copy_paste_enabled     = true
  file_copy_enabled      = true
  shareable_link_enabled = true
  tunneling_enabled      = true
  ip_connect_enabled     = false
  tags                   = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_bastion.0.id
    public_ip_address_id = azurerm_public_ip.public_ip_bastion.0.id
  }
}

# module "diagnostic_setting_bastion" {
#   count                      = var.enable_bastion && var.enable_monitoring ? 1 : 0
#   source                     = "./modules/diagnostic_setting"
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
#   target_resource_id         = azurerm_bastion_host.bastion_host.0.id
# }

# module "diagnostic_setting_bastion_public_ip" {
#   count                      = var.enable_bastion && var.enable_monitoring ? 1 : 0
#   source                     = "./modules/diagnostic_setting"
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
#   target_resource_id         = azurerm_public_ip.public_ip_bastion.0.id
# }

# output "monitor_diagnostic_categories_bastion_public_ip" {
#   value = var.enable_monitoring && var.enable_monitoring_output ? module.diagnostic_setting_bastion_public_ip.0.monitor_diagnostic_categories : null
# }