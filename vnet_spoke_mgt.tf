resource "azurerm_virtual_network" "vnet_spoke_mgt" {
  count               = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "vnet-spoke-mgt1" #TODO
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.0.name
  address_space       = var.cidr_vnet_spoke_mgt
  dns_servers         = [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address]

  tags = var.tags
}

resource "azurerm_subnet" "subnet_mgt" {
  count                = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                 = var.subnet_mgt
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.0.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.0.resource_group_name
  address_prefixes     = var.cidr_subnet_mgt
}

resource "azurerm_subnet" "subnet_bastion" {
  count                = var.enable_bastion ? 1 : 0
  name                 = var.subnet_bastion
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.0.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.0.resource_group_name
  address_prefixes     = var.cidr_subnet_bastion
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_vnet_mgt" {
  count                      = var.enable_monitoring && (var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux) ? 1 : 0
  name                       = "diagnostic-settings"
  target_resource_id         = azurerm_virtual_network.vnet_spoke_mgt.0.id
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