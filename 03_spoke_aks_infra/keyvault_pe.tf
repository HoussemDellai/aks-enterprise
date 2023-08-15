# https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/private_endpoint.tf
resource "azurerm_private_endpoint" "pe_keyvault" {
  count               = var.enable_private_keyvault && var.enable_keyvault ? 1 : 0
  name                = "private-endpoint-keyvault"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet_pe.0.id
  tags                = var.tags

  private_service_connection {
    name                           = "connection-keyvault"
    private_connection_resource_id = azurerm_key_vault.kv.0.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-keyvault"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_keyvault.0.id]
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone_keyvault" {
  count               = var.enable_private_keyvault && var.enable_keyvault ? 1 : 0
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_keyvault_to_vnet_hub" {
  count                 = var.enable_hub_spoke && var.enable_private_keyvault && var.enable_keyvault ? 1 : 0
  name                  = "link_private_dns_zone_keyvault_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_keyvault.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_keyvault.0.name
  virtual_network_id    = data.terraform_remote_state.hub.0.outputs.vnet_hub.id # azurerm_virtual_network.vnet_hub.0.id
}