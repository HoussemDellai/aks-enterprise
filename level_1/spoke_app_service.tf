resource "azurerm_subnet" "snet_spoke_appservice_vnetintegration" {
  count                = var.enable_spoke_appservice ? 1 : 0
  name                 = "snet-vnet-integration"
  resource_group_name  = azurerm_resource_group.rg_spoke3.0.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_appservice.0.name
  address_prefixes     = ["10.3.1.0/24"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      # actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "snet_spoke_appservice_pe" {
  count                                     = var.enable_spoke_appservice ? 1 : 0
  name                                      = "snet-private-endpoint"
  resource_group_name                       = azurerm_resource_group.rg_spoke3.0.name
  virtual_network_name                      = azurerm_virtual_network.vnet_spoke_appservice.0.name
  address_prefixes                          = ["10.3.2.0/24"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_service_plan" "service_plan" {
  count               = var.enable_spoke_appservice ? 1 : 0
  name                = "service-plan"
  location            = azurerm_resource_group.rg_spoke3.0.location
  resource_group_name = azurerm_resource_group.rg_spoke3.0.name
  os_type             = "Linux"
  sku_name            = "P1v3"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "webapp_frontent" {
  count                     = var.enable_spoke_appservice ? 1 : 0
  name                      = "webapp-frontent-011"
  location                  = azurerm_resource_group.rg_spoke3.0.location
  resource_group_name       = azurerm_resource_group.rg_spoke3.0.name
  service_plan_id           = azurerm_service_plan.service_plan.0.id
  virtual_network_subnet_id = azurerm_subnet.snet_spoke_appservice_vnetintegration.0.id
  tags                      = var.tags

  app_settings = {
    "WEBSITE_DNS_SERVER" : "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL" : "1"
  }

  site_config {}

  lifecycle {
    ignore_changes = [
      app_settings
    ]
  }
}

# The following resources support associating the vNet for Regional vNet Integration directly on the resource 
# and via the azurerm_app_service_virtual_network_swift_connection resource. You can't use both simultaneously.
# resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
#   app_service_id = azurerm_linux_web_app.webapp_frontent.id
#   subnet_id      = azurerm_subnet.snet_vnet_integration.id
# }

resource "azurerm_linux_web_app" "webapp_backend" {
  count               = var.enable_spoke_appservice ? 1 : 0
  name                = "webapp-backend-011"
  location            = azurerm_resource_group.rg_spoke3.0.location
  resource_group_name = azurerm_resource_group.rg_spoke3.0.name
  service_plan_id     = azurerm_service_plan.service_plan.0.id
  https_only          = true
  tags                = var.tags

  site_config {
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_private_dns_zone" "dnsprivatezone" {
  count               = var.enable_spoke_appservice ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg_spoke3.0.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  count                 = var.enable_spoke_appservice ? 1 : 0
  name                  = "dnszonelink"
  resource_group_name   = azurerm_resource_group.rg_spoke3.0.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_spoke_appservice.0.id
}

resource "azurerm_private_endpoint" "pe_backend" {
  count               = var.enable_spoke_appservice ? 1 : 0
  name                = "private-endpoint-backend"
  location            = azurerm_resource_group.rg_spoke3.0.location
  resource_group_name = azurerm_resource_group.rg_spoke3.0.name
  subnet_id           = azurerm_subnet.snet_spoke_appservice_pe.0.id
  tags                = var.tags

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.0.id]
  }

  private_service_connection {
    name                           = "pe-connection"
    private_connection_resource_id = azurerm_linux_web_app.webapp_backend.0.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  count                  = var.enable_spoke_appservice ? 1 : 0
  app_id                 = azurerm_linux_web_app.webapp_frontent.0.id
  repo_url               = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch                 = "master"
  use_manual_integration = true
  use_mercurial          = false
}