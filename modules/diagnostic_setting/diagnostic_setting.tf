# src: https://github.com/claranet/terraform-azurerm-diagnostic-settings/blob/master/r-diagnostic.tf

data "azurerm_monitor_diagnostic_categories" "categories" {
  resource_id = var.target_resource_id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                           = "diagnostic-settings"
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated" # "AzureDiagnostics" # 
  # storage_account_id             = local.storage_id
  # eventhub_authorization_rule_id = local.eventhub_authorization_rule_id
  # eventhub_name                  = local.eventhub_name

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.log_category_types

    content {
      category = enabled_log.key

      retention_policy {
        enabled = true
        days    = 7
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.metrics

    content {
      category = metric.key

      retention_policy {
        enabled = true
        days    = 7
      }
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}

output "monitor_diagnostic_categories" {
  value = join(", ", data.azurerm_monitor_diagnostic_categories.categories.log_category_types, data.azurerm_monitor_diagnostic_categories.categories.metrics)
}

# output diagnostic_categories_metrics {
#   value = data.azurerm_monitor_diagnostic_categories.categories.metrics
# }