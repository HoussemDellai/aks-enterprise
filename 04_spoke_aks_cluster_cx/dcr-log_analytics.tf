resource "azurerm_monitor_data_collection_rule" "dcr-log-analytics" {
  name                        = "dcr-log-analytics"
  resource_group_name           = azurerm_resource_group.rg-monitoring.name
  location                      = azurerm_resource_group.rg-monitoring.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce-log-analytics.id

  destinations {
    log_analytics {
      name                  = "log_analytics"
      workspace_resource_id = data.terraform_remote_state.management.outputs.log_analytics_workspace.id
    }
  }

  data_flow {
    streams      = ["Microsoft-ContainerInsights-Group-Default"]
    destinations = ["log_analytics"]
  }

  data_sources {
    syslog {
      name = "example-syslog"
      streams = ["Microsoft-Syslog"]
      facility_names = [
        "*"
      ]
      log_levels = [
        "Debug",
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency",
      ]
    }
    extension {
      extension_name = "ContainerInsights"
      name           = "ContainerInsightsExtension"
      streams        = ["Microsoft-ContainerInsights-Group-Default"]
      extension_json = jsonencode(
        {
          dataCollectionSettings = {
            enableContainerLogV2   = true
            interval               = "1m"
            namespaceFilteringMode = "Off"
          }
        }
      )
    }
  }
}