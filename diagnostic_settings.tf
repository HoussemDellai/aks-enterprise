# # Get resources by type
# data "azurerm_resources" "subnets" {
#   type = "Microsoft.Network/virtualNetworks/subnets"
#   required_tags = var.tags
# }

##################################################################
# Diagnostic Settings for all NSGs
##################################################################

data "azurerm_resources" "nsg" {
  type          = "Microsoft.Network/networkSecurityGroups"
  required_tags = var.tags
}

module "diagnostic_setting_nsg" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.nsg.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.nsg.resources[count.index].id
}

output "monitor_diagnostic_categories_nsg" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_nsg.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all VNETs
##################################################################

data "azurerm_resources" "vnet" {
  type          = "Microsoft.Network/virtualNetworks"
  required_tags = var.tags
}

module "diagnostic_setting_vnet" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.vnet.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.vnet.resources[count.index].id
}

output "monitor_diagnostic_categories_vnet" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_vnet.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all Public IP
##################################################################

data "azurerm_resources" "public_ip" {
  type          = "Microsoft.Network/publicIPAddresses"
  required_tags = var.tags
}

module "diagnostic_setting_public_ip" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.public_ip.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.public_ip.resources[count.index].id
}

output "monitor_diagnostic_categories_public_ip" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_public_ip.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all AKS
##################################################################

data "azurerm_resources" "aks" {
  type          = "Microsoft.ContainerService/managedClusters"
  required_tags = var.tags
}

module "diagnostic_setting_aks" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.aks.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.aks.resources[count.index].id
}

output "monitor_diagnostic_categories_aks" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_aks.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all ACR
##################################################################

data "azurerm_resources" "acr" {
  type          = "Microsoft.ContainerRegistry/registries"
  required_tags = var.tags
}

module "diagnostic_setting_acr" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.acr.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.acr.resources[count.index].id
}

output "monitor_diagnostic_categories_acr" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_acr.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all Storage Accounts
##################################################################

data "azurerm_resources" "storage_account" {
  type          = "Microsoft.Storage/storageAccounts"
  required_tags = var.tags
}

module "diagnostic_setting_storage_account" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.storage_account.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.storage_account.resources[count.index].id
}

output "monitor_diagnostic_categories_storage_account" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_storage_account.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all Storage Accounts Blobs, Files, Queues, Tables
##################################################################

##################################################################
# Diagnostic Settings for all Firewall
##################################################################

data "azurerm_resources" "firewall" {
  type          = "Microsoft.Network/azureFirewalls"
  required_tags = var.tags
}

module "diagnostic_setting_firewall" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.firewall.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.firewall.resources[count.index].id
}

output "monitor_diagnostic_categories_firewall" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_firewall.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all Key vault
##################################################################

data "azurerm_resources" "keyvault" {
  type          = "Microsoft.KeyVault/vaultss"
  required_tags = var.tags
}

module "diagnostic_setting_keyvault" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.keyvault.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.keyvault.resources[count.index].id
}

output "monitor_diagnostic_categories_keyvault" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_keyvault.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all VMs
##################################################################

data "azurerm_resources" "vm" {
  type          = "Microsoft.Compute/virtualMachines"
  required_tags = var.tags
}

module "diagnostic_setting_vm" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.vm.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.vm.resources[count.index].id
}

output "monitor_diagnostic_categories_vm" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_vm.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all NICs
##################################################################

data "azurerm_resources" "nic" {
  type          = "Microsoft.Network/networkInterfaces"
  required_tags = var.tags
}

module "diagnostic_setting_nic" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.nic.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.nic.resources[count.index].id
}

output "monitor_diagnostic_categories_nic" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_nic.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all Bastion hosts
##################################################################

data "azurerm_resources" "bastion" {
  type          = "Microsoft.Network/bastionHosts"
  required_tags = var.tags
}

module "diagnostic_setting_bastion" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.bastion.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.bastion.resources[count.index].id
}

output "monitor_diagnostic_categories_bastion" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_bastion.*.monitor_diagnostic_categories : null
}

##################################################################
# Diagnostic Settings for all Application Gateway
##################################################################

data "azurerm_resources" "application_gateway" {
  type          = "Microsoft.Network/applicationGateways"
  required_tags = var.tags
}

module "diagnostic_setting_application_gateway" {
  count                      = var.enable_diagnostic_settings ? length(data.azurerm_resources.application_gateway.resources) : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = data.azurerm_resources.application_gateway.resources[count.index].id
}

output "monitor_diagnostic_categories_application_gateway" {
  value = var.enable_diagnostic_settings && var.enable_diagnostic_settings_output ? module.diagnostic_setting_application_gateway.*.monitor_diagnostic_categories : null
}

# # Get resources by type, create spoke vNet peerings
# data "azurerm_resources" "spokes" {
#   type = "Microsoft.Network/virtualNetworks"

#   required_tags = {
#     environment = "production"
#     role        = "spokeNetwork"
#   }
# }