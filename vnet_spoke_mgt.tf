resource "azurerm_virtual_network" "vnet_spoke_mgt" {
  count               = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "vnet-spoke-mgt"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.0.name
  address_space       = var.cidr_vnet_spoke_mgt
  dns_servers         = [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_mgt" {
  count                = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                 = "subnet-mgt"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.0.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.0.resource_group_name
  address_prefixes     = var.cidr_subnet_mgt
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_mgt" {
  count          = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_mgt.0.id
  route_table_id = azurerm_route_table.route_table_to_firewall.0.id
}

resource "azurerm_network_security_group" "nsg_subnet_mgt" {
  count               = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "nsg_subnet_mgt"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.0.name
  tags                = var.tags

  security_rule {
    name                                       = "rule_subnet_mgt"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_address_prefix                      = "*"
    destination_address_prefix                 = "*"
    description                                = ""
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = []
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_ranges                         = []
  }
}

resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_mgt" {
  count                     = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet_mgt.0.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_mgt.0.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_vnet_mgt" {
  count                          = var.enable_monitoring && (var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux) ? 1 : 0
  name                           = "diagnostic-settings"
  target_resource_id             = azurerm_virtual_network.vnet_spoke_mgt.0.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.0.id
  log_analytics_destination_type = "AzureDiagnostics" # "Dedicated"

  enabled_log {
    category = "VMProtectionAlerts"

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
}
