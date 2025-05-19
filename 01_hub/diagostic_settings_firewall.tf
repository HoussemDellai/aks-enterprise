data "azurerm_monitor_diagnostic_categories" "categories-firewall" {
  provider    = azurerm.subscription_hub
  resource_id = azurerm_firewall.firewall.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics_firewall" {
  provider = azurerm.subscription_hub

  name                           = "diagnostics-firewall"
  target_resource_id             = azurerm_firewall.firewall.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.id
  log_analytics_destination_type = "Dedicated" # "AzureDiagnostics"


  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-firewall.log_category_types

    content {
      category = enabled_log.key
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories-firewall.metrics

    content {
      category = metric.key
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}
