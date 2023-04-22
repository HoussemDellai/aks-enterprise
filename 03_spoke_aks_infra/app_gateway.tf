resource "azurerm_subnet" "subnet_appgw" {
  count                = var.enable_app_gateway ? 1 : 0
  name                 = "subnet-appgw"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_appgateway
}

# Locals block for hardcoded names
locals {
  backend_address_pool_name      = "appgw-beap"
  frontend_port_name             = "appgw-feport"
  frontend_ip_configuration_name = "appgw-feip"
  http_setting_name              = "appgw-be-htst"
  listener_name                  = "appgw-httplstn"
  request_routing_rule_name      = "appgw-rqrt"
}

# Public Ip 
resource "azurerm_public_ip" "appgw_pip" {
  count               = var.enable_app_gateway ? 1 : 0
  name                = "public-ip-appgw"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  count               = var.enable_app_gateway ? 1 : 0
  name                = "appgw-aks"
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  location            = var.resources_location
  tags                = var.tags

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1 # 2
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.subnet_appgw.0.id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_port {
    name = "httpsPort"
    port = 443
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.0.id
  }
  backend_address_pool {
    name = local.backend_address_pool_name
  }
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 10000 # value from 1 to 20000
  }

  lifecycle {
    # prevent_destroy       = true
    create_before_destroy = true

    ignore_changes = [
      # all, # ignore all attributes
      tags,
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      frontend_port,
      request_routing_rule
    ]
  }

  depends_on = [
    azurerm_virtual_network.vnet_spoke_aks,
    azurerm_public_ip.appgw_pip
  ]
}