resource "azurerm_private_endpoint" "pe-ai-services" {
  name                = "pe-ai-services"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet-ai.id

  private_service_connection {
    name                           = "pe-connection"
    private_connection_resource_id = azurerm_ai_services.ai-services.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "private-dns-zone-group"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.privatelink-services-ai-azure-com.id,
      azurerm_private_dns_zone.privatelink-openai-azure-com.id,
      azurerm_private_dns_zone.privatelink-cognitiveservices-azure-com.id
    ]
  }
}

resource "azurerm_private_dns_zone" "privatelink-cognitiveservices-azure-com" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "privatelink-openai-azure-com" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "privatelink-services-ai-azure-com" {
  name                = "privatelink.services.ai.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink-cognitiveservices-azure-com" {
  name                  = "privatelink-cognitiveservices-azure-com"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink-cognitiveservices-azure-com.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink-openai-azure-com" {
  name                  = "privatelink-openai-azure-com"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink-openai-azure-com.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink-services-ai-azure-com" {
  name                  = "privatelink-services-ai-azure-com"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink-services-ai-azure-com.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
}
