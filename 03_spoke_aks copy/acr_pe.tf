# https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/private_endpoint.tf
resource "azurerm_private_endpoint" "pe_acr" {
  count               = var.enable_private_acr ? 1 : 0
  name                = "private-endpoint-acr"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  subnet_id           = azurerm_subnet.subnet_spoke_aks_pe.0.id
  tags                = var.tags

  private_service_connection {
    name                           = "connection-acr"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-acr"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_acr.0.id]
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone_acr" {
  count               = var.enable_private_acr ? 1 : 0
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_zone_acr_to_vnet_hub" {
  count                 = var.enable_hub_spoke && var.enable_private_acr ? 1 : 0
  name                  = "link_private_dns_zone_acr_to_vnet_hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_acr.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_acr.0.name
  virtual_network_id    = data.terraform_remote_state.hub.0.outputs.vnet_hub_id # azurerm_virtual_network.vnet_hub.id
}