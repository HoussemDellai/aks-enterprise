resource "azurerm_monitor_diagnostic_setting" "aks_diagnostic_settings" {
  name                           = "aks-diagnostic-settings"
  target_resource_id             = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated" # AzureDiagnostics 
  #   storage_account_id = azurerm_storage_account.example.id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  enabled_log {
    category = "cloud-controller-manager"
  }

  enabled_log {
    category = "guard"
  }

  enabled_log {
    category = "csi-azuredisk-controller"
  }

  enabled_log { # to be disabled
    category = "kube-audit"
  }

  enabled_log { # to be disabled
    category = "csi-azurefile-controller"
  }

  enabled_log { # to be disabled
    category = "csi-snapshot-controller"
  }

  metric {
    category = "AllMetrics"
  }
}
