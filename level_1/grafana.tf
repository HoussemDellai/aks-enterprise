resource azurerm_dashboard_grafana" "grafana_aks" {
  count                             = var.enable_grafana_prometheus ? 1 : 0
  name                              = "grafana-aks-011"
  resource_group_name               = azurerm_resource_group.rg_spoke_app.name
  location                          = azurerm_resource_group.rg_spoke_app.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  sku                               = "Standard"
  zone_redundancy_enabled           = true

  identity {
    type = "SystemAssigned" # The only possible values is SystemAssigned
  }

  tags = var.tags
}

resource azurerm_role_assignment" "role_grafana_admin" {
  count                = var.enable_grafana_prometheus ? 1 : 0
  scope                = azurerm_dashboard_grafana.grafana_aks.0.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource azurerm_role_assignment" "role_monitoring_data_reader" {
  count                = var.enable_grafana_prometheus ? 1 : 0
  scope                = azapi_resource.monitor_workspace_aks.0.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_aks.0.identity.0.principal_id
}

# https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/grafana-plugin
# to monitor all Azure resources
resource azurerm_role_assignment" "role_monitoring_reader" {
  count                = var.enable_grafana_prometheus ? 1 : 0
  scope                = data.azurerm_subscription.subscription_spoke.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_aks.0.identity.0.principal_id
}

# https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/azure-monitor-workspace-overview?tabs=resource-manager#create-an-azure-monitor-workspace
resource azapi_resource" "monitor_workspace_aks" {
  count     = var.enable_grafana_prometheus ? 1 : 0
  type      = "microsoft.monitor/accounts@2021-06-03-preview"
  name      = "monitor-workspace-aks"
  parent_id = azurerm_resource_group.rg_spoke_app.id
  location  = azurerm_resource_group.rg_spoke_app.location
}

# resource azapi_update_resource" "grafana_monitor_workspace_integration" {
#   type        = "Microsoft.Dashboard/grafana@2022-08-01"
#   resource_id = azurerm_dashboard_grafana.grafana_aks.id

#   body = jsonencode({
#     properties = {
#       grafanaIntegrations = {
#         azureMonitorWorkspaceIntegrations = [
#           {
#             azureMonitorWorkspaceResourceId = azapi_resource.monitor_workspace_aks.id
#           }
#         ]
#       }
#     }
#   })
# }

resource null_resource" "aks_enable_azuremonitormetrics" {
  count = var.enable_grafana_prometheus ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT

    az aks update --enable-azuremonitormetrics `
                  -g ${azurerm_kubernetes_cluster.aks.0.resource_group_name} `
                  -n ${azurerm_kubernetes_cluster.aks.0.name} `
                  --azure-monitor-workspace-resource-id ${azapi_resource.monitor_workspace_aks.0.id} `
                  --grafana-resource-id ${azurerm_dashboard_grafana.grafana_aks.0.id}

    EOT
  }

  triggers = {
    "key" = "value2"
    # trigger = timestamp()
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks[0],
    azurerm_dashboard_grafana.grafana_aks,
    azapi_resource.monitor_workspace_aks,
    azurerm_kubernetes_cluster_node_pool.poolapps[0],
    azurerm_kubernetes_cluster_node_pool.poolspot[0]
  ]
}

# resource azapi_resource" "grafana_aks" {
#   type        = "Microsoft.Dashboard/grafana@2022-08-01" 
#   name        = "grafana-aks-013"
#   parent_id   = azurerm_resource_group.rg_spoke_app.id
#   location    = azurerm_resource_group.rg_spoke_app.location

#   identity {
#     type      = "SystemAssigned"
#   }

#   body = jsonencode({
#     sku = {
#       name = "Standard"
#     }
#     properties = {
#       publicNetworkAccess = "Enabled",
#       zoneRedundancy = "Enabled",
#       apiKey = "Enabled",
#       deterministicOutboundIP = "Enabled"
#     }
#   })
# }

output "grafana_endpoint" {
  value = var.enable_grafana_prometheus ? azurerm_dashboard_grafana.grafana_aks.0.endpoint : null
}
