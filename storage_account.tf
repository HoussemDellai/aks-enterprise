resource "azurerm_private_dns_zone" "private_dns_zone_storage" {
  count               = var.enable_storage_account ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_spoke_app.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_storage_link_hub" {
  count                 = var.enable_storage_account ? 1 : 0
  name                  = "private_dns_zone_storage_link_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_storage.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_storage.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}

resource "azurerm_private_endpoint" "pe_storage" {
  count               = var.enable_storage_account ? 1 : 0
  name                = "private-endpoint-storage"
  resource_group_name = azurerm_resource_group.rg_spoke_app.name
  location            = var.resources_location
  subnet_id           = azurerm_subnet.subnet_pe.0.id
  private_service_connection {
    name                           = "connection_storage"
    private_connection_resource_id = azurerm_storage_account.storage.0.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_storage.0.id]
  }
}

resource "azurerm_storage_account_network_rules" "rules_storage" {
  count                      = var.enable_storage_account ? 1 : 0
  storage_account_id         = azurerm_storage_account.storage.0.id
  default_action             = "Deny"
  bypass                     = ["Metrics", "Logging", "AzureServices"]
  ip_rules                   = [data.http.machine_ip.response_body]
  virtual_network_subnet_ids = null # [azurerm_subnet.subnet_mgt.0.id]
}

resource "azurerm_storage_account" "storage" {
  count                         = var.enable_storage_account ? 1 : 0
  name                          = var.storage_account_name
  resource_group_name           = azurerm_resource_group.rg_spoke_app.name
  location                      = var.resources_location
  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
}

resource "azurerm_storage_container" "container" {
  count                 = var.enable_storage_account ? 1 : 0
  name                  = "my-files"
  storage_account_name  = azurerm_storage_account.storage.0.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_blob" "blob" {
  count                  = var.enable_storage_account ? 1 : 0
  name                   = "aks.tf"
  storage_account_name   = azurerm_storage_account.storage.0.name
  storage_container_name = azurerm_storage_container.container.0.name
  type                   = "Block"
  source                 = "aks.tf"
}

module "diagnostic_setting_storage" {
  count                      = var.enable_monitoring && var.enable_storage_account ? 1 : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = azurerm_storage_account.storage.0.id
}

output "azurerm_monitor_diagnostic_categories_storage" {
  value = module.diagnostic_setting_storage.0.azurerm_monitor_diagnostic_categories
}