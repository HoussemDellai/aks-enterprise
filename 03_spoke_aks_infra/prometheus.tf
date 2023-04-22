# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/azure-monitor-workspace-overview?tabs=resource-manager#create-an-azure-monitor-workspace
resource "azapi_resource" "monitor_workspace_aks" {
  count     = var.enable_grafana_prometheus ? 1 : 0
  type      = "microsoft.monitor/accounts@2021-06-03-preview"
  name      = "monitor-workspace-aks"
  parent_id = azurerm_resource_group.rg_spoke_aks.id
  location  = azurerm_resource_group.rg_spoke_aks.location
}