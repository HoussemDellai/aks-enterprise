resource "azurerm_network_watcher_flow_log" "network_flow_logs" {
#   count                     = var.enable_nsg_flow_logs && var.enable_monitoring && (var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux) ? 1 : 0
  name                      = "network_flow_logs_nsg"
  network_watcher_name      = azurerm_network_watcher.network_watcher_regional.0.name
  resource_group_name       = azurerm_network_watcher.network_watcher_regional.0.resource_group_name
  network_security_group_id = azurerm_network_security_group.nsg_subnet_mgt.0.id
  storage_account_id        = azurerm_storage_account.network_log_data.0.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
    workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
    interval_in_minutes   = 10
  }
}