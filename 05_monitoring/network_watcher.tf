# resource azurerm_network_watcher network_watcher_regional {
#   count               = var.enable_nsg_flow_logs ? 1 : 0
#   name                = "NetworkWatcher_${var.resources_location}"
#   location            = var.resources_location
#   resource_group_name = azurerm_resource_group.rg_network_watcher.0.name
# }

# The Network Watcher Instance & network log flow
# There can only be one Network Watcher per subscription and region
data "azurerm_network_watcher" "network_watcher_regional" {
  name                = "NetworkWatcher_${var.resources_location}"
  resource_group_name = "NetworkWatcherRG"
}

# Log collection components
resource "azurerm_storage_account" "network_log_data" {
  count                    = var.enable_nsg_flow_logs ? 1 : 0
  name                     = "storageforlogs011"
  resource_group_name      = data.azurerm_network_watcher.network_watcher_regional.resource_group_name
  location                 = var.resources_location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_replication_type = "LRS"
  tags                     = var.tags
}

data "azurerm_resources" "nsg_flowlogs" {
  type          = "Microsoft.Network/networkSecurityGroups"
  required_tags = var.tags
}

locals {
  nsg = tomap({
    for nsg in data.azurerm_resources.nsg_flowlogs.resources :
    nsg.name => {
      name = nsg.name
      id   = nsg.id
    }
  })
}

module "azurerm_network_watcher_flow_log" {
  for_each = local.nsg # azurerm_network_security_group.nsg # 
  source   = "../modules/azurerm_network_watcher_flow_log"

  nsg_name                  = each.value.name
  network_security_group_id = each.value.id
  network_watcher_name      = data.azurerm_network_watcher.network_watcher_regional.name
  resource_group_name       = data.azurerm_network_watcher.network_watcher_regional.resource_group_name
  storage_account_id        = azurerm_storage_account.network_log_data.0.id

  workspace_id          = data.terraform_remote_state.management.0.outputs.log_analytics_workspace.workspace_id
  workspace_region      = data.terraform_remote_state.management.0.outputs.log_analytics_workspace.location
  workspace_resource_id = data.terraform_remote_state.management.0.outputs.log_analytics_workspace.id
}
