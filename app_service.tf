resource "azurerm_resource_group" "rg_spoke3" {
  name     = "rg-spoke3"
  location = var.resources_location
}

resource "azurerm_virtual_network" "vnet_spoke3" {
  name                = "vnet_spoke3"
  location            = azurerm_resource_group.rg_spoke3.location
  resource_group_name = azurerm_resource_group.rg_spoke3.name
  address_space       = ["10.3.0.0/16"]
}

resource "azurerm_subnet" "snet_vnet_integration" {
  name                 = "snet-vnet-integration"
  resource_group_name  = azurerm_resource_group.rg_spoke3.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke3.name
  address_prefixes     = ["10.3.1.0/24"]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "snet_pe" {
  name                                      = "snet-private-endpoint"
  resource_group_name                       = azurerm_resource_group.rg_spoke3.name
  virtual_network_name                      = azurerm_virtual_network.vnet_spoke3.name
  address_prefixes                          = ["10.3.2.0/24"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_service_plan" "service_plan" {
  name                = "service-plan"
  location            = azurerm_resource_group.rg_spoke3.location
  resource_group_name = azurerm_resource_group.rg_spoke3.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "webapp_frontent" {
  name                = "webapp-frontent-011"
  location            = azurerm_resource_group.rg_spoke3.location
  resource_group_name = azurerm_resource_group.rg_spoke3.name
  service_plan_id     = azurerm_service_plan.service_plan.id

  app_settings = {
    "WEBSITE_DNS_SERVER" : "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL" : "1"
  }

  site_config {}
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id = azurerm_linux_web_app.webapp_frontent.id
  subnet_id      = azurerm_subnet.snet_vnet_integration.id
}

resource "azurerm_linux_web_app" "webapp_backend" {
  name                = "webapp-backend-011"
  location            = azurerm_resource_group.rg_spoke3.location
  resource_group_name = azurerm_resource_group.rg_spoke3.name
  service_plan_id     = azurerm_service_plan.service_plan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_private_dns_zone" "dnsprivatezone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg_spoke3.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  name                  = "dnszonelink"
  resource_group_name   = azurerm_resource_group.rg_spoke3.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.name
  virtual_network_id    = azurerm_virtual_network.vnet_spoke3.id
}

resource "azurerm_private_endpoint" "pe_backend" {
  name                = "private-endpoint-backend"
  location            = azurerm_resource_group.rg_spoke3.location
  resource_group_name = azurerm_resource_group.rg_spoke3.name
  subnet_id           = azurerm_subnet.snet_pe.id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
  }

  private_service_connection {
    name                           = "pe-connection"
    private_connection_resource_id = azurerm_linux_web_app.webapp_backend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id                 = azurerm_linux_web_app.webapp_frontent.id
  repo_url               = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch                 = "master"
  use_manual_integration = true
  use_mercurial          = false
}
