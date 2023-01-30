# Log collection components
resource "azurerm_storage_account" "network_log_data" {
  count                    = var.enable_nsg_flow_logs ? 1 : 0
  name                     = "storageforlogs011"
  resource_group_name      = var.rg_network_watcher
  location                 = var.resources_location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# The Network Watcher Instance & network log flow
# There can only be one Network Watcher per subscription and region
data "azurerm_network_watcher" "network_watcher_regional" {
  name                = "NetworkWatcher_${var.resources_location}"
  resource_group_name = var.rg_network_watcher
}

# resource "azurerm_network_watcher" "network_watcher_regional" {
#   count               = var.enable_nsg_flow_logs ? 1 : 0
#   name                = "NetworkWatcher_${var.resources_location}"
#   location            = var.resources_location
#   resource_group_name = azurerm_resource_group.rg_network_watcher.0.name
# }

data "azurerm_resources" "nsg_flowlogs" {
  type          = "Microsoft.Network/networkSecurityGroups"
  required_tags = var.tags
}

module "azurerm_network_watcher_flow_log" {
  count                     = var.enable_nsg_flow_logs ? length(data.azurerm_resources.nsg_flowlogs.resources) : 0
  source                    = "../modules/azurerm_network_watcher_flow_log"
  nsg_name                  = data.azurerm_resources.nsg_flowlogs.resources[count.index].name
  network_watcher_name      = data.azurerm_network_watcher.network_watcher_regional.name
  resource_group_name       = data.azurerm_network_watcher.network_watcher_regional.resource_group_name
  network_security_group_id = data.azurerm_resources.nsg_flowlogs.resources[count.index].id
  storage_account_id        = azurerm_storage_account.network_log_data.0.id

  workspace_id          = data.azurerm_log_analytics_workspace.workspace.workspace_id
  workspace_region      = data.azurerm_log_analytics_workspace.workspace.location
  workspace_resource_id = data.azurerm_log_analytics_workspace.workspace.id
}

output "azurerm_resources_nsg_flowlogs" {
  value = data.azurerm_resources.nsg_flowlogs.resources[*].name
}