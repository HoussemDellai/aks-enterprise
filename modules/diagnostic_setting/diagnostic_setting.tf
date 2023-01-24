# src: https://github.com/claranet/terraform-azurerm-diagnostic-settings/blob/master/r-diagnostic.tf

data "azurerm_monitor_diagnostic_categories" "categories" {
  resource_id = var.target_resource_id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                           = "diagnostic-settings"
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics" # "Dedicated"
# storage_account_id             = local.storage_id
# eventhub_authorization_rule_id = local.eventhub_authorization_rule_id
# eventhub_name                  = local.eventhub_name

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories.log_category_types

    content {
      category = enabled_log.key

      retention_policy {
        enabled = true
        # days    = 7
      }
    }
  }

#   enabled_log {
#     category = var.log_categories[0] # "kube-apiserver"

#     retention_policy {
#       enabled = true
#     }
#   }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}

# locals {
#   log_categories = (
#     var.log_categories != null ?
#     var.log_categories :
#     try(data.azurerm_monitor_diagnostic_categories.categories.log_category_types, [])
#   )
#   metric_categories = (
#     var.metric_categories != null ?
#     var.metric_categories :
#     try(data.azurerm_monitor_diagnostic_categories.categories.metrics, [])
#   )

#   logs = {
#     for category in try(data.azurerm_monitor_diagnostic_categories.categories.log_category_types, []) : category => {
#       enabled        = contains(local.log_categories, category)
#       retention_days = var.retention_days
#     }
#   }

#   metrics = {
#     for metric in try(data.azurerm_monitor_diagnostic_categories.categories.metrics, []) : metric => {
#       enabled        = contains(local.metric_categories, metric)
#       retention_days = var.retention_days
#     }
#   }
# }

output "azurerm_monitor_diagnostic_categories" {
  value = data.azurerm_monitor_diagnostic_categories.categories.log_category_types
}