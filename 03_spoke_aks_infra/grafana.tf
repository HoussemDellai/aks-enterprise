resource "azurerm_dashboard_grafana" "grafana_aks" {
  count                             = var.enable_grafana_prometheus ? 1 : 0
  name                              = "grafana-aks-011"
  resource_group_name               = azurerm_resource_group.rg_spoke_aks.name
  location                          = azurerm_resource_group.rg_spoke_aks.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  sku                               = "Standard"
  zone_redundancy_enabled           = true

  azure_monitor_workspace_integrations {
    resource_id = azapi_resource.monitor_workspace_aks.0.id
  }

  identity {
    type = "SystemAssigned" # The only possible values is SystemAssigned
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "role_grafana_admin" {
  count                = var.enable_grafana_prometheus ? 1 : 0
  scope                = azurerm_dashboard_grafana.grafana_aks.0.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
  # principal_id         = "4f932ce5-0f06-46ee-b3cf-3a6a1f3e26f1"
}

resource "azurerm_role_assignment" "role_monitoring_data_reader" {
  count                = var.enable_grafana_prometheus ? 1 : 0
  scope                = azapi_resource.monitor_workspace_aks.0.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_aks.0.identity.0.principal_id
}

# https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/grafana-plugin
# to monitor all Azure resources
resource "azurerm_role_assignment" "role_monitoring_reader" {
  count                = var.enable_grafana_prometheus ? 1 : 0
  scope                = data.azurerm_subscription.subscription_spoke.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_aks.0.identity.0.principal_id
}