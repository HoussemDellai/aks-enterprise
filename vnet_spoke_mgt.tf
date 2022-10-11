resource "azurerm_virtual_network" "vnet_spoke_mgt" {
  name                = "vnet-spoke-mgt"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.name
  address_space       = var.cidr_vnet_spoke_mgt

  tags = var.tags
}

resource "azurerm_subnet" "subnet_mgt" {
  name                 = var.subnet_mgt
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.resource_group_name
  address_prefixes     = var.cidr_subnet_mgt
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_vnet_mgt" {
  count                      = var.enable_monitoring ? 1 : 0
  name                       = "diagnostic-settings"
  target_resource_id         = azurerm_virtual_network.vnet_spoke_mgt.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id

  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}