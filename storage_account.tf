resource "azurerm_private_dns_zone" "private_dns_zone_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_spoke_app.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_storage_link_hub" {
  name                  = "private_dns_zone_storage_link_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_storage.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_storage.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.0.id
}

resource "azurerm_private_endpoint" "pe_storage" {
  name                = "private-endpoint-storage"
  resource_group_name = azurerm_resource_group.rg_spoke_app.name
  location            = var.resources_location
  subnet_id           = azurerm_subnet.subnet_pe.0.id
  private_service_connection {
    name                           = "connection_storage"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_storage.id]
  }
}

resource "azurerm_storage_account_network_rules" "rules_storage" {
  storage_account_id         = azurerm_storage_account.storage.id
  default_action             = "Deny"
  bypass                     = ["Metrics", "Logging", "AzureServices"]
  ip_rules                   = [data.http.machine_ip.response_body]
  virtual_network_subnet_ids = null # [azurerm_subnet.subnet_mgt.0.id]
}

resource "azurerm_storage_account" "storage" {
  name                          = var.storage_account_name
  resource_group_name           = azurerm_resource_group.rg_spoke_app.name
  location                      = var.resources_location
  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
}

resource "azurerm_storage_container" "container" {
  name                  = "my-files"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "aks.tf"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "aks.tf"
}

#TODO add diag set