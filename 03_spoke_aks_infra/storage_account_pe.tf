resource "azurerm_private_dns_zone" "private_dns_zone_storage" {
  count               = var.enable_storage_account ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_storage_link_hub" {
  count                 = var.enable_storage_account && var.enable_hub_spoke ? 1 : 0
  name                  = "private_dns_zone_storage_link_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_storage.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_storage.0.name
  virtual_network_id    = data.terraform_remote_state.hub.0.outputs.vnet_hub.id # azurerm_virtual_network.vnet_hub.0.id
}

resource "azurerm_private_endpoint" "pe_storage" {
  count               = var.enable_storage_account ? 1 : 0
  name                = "private-endpoint-storage"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  subnet_id           = azurerm_subnet.subnet_pe.0.id
  tags                = var.tags

  private_service_connection {
    name                           = "connection-storage"
    private_connection_resource_id = azurerm_storage_account.storage.0.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_storage.0.id]
  }
}