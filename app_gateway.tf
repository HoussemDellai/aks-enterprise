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
  resource_group_name = azurerm_resource_group.rg_aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  # for_each            = var.enable_app_gateway ? ["any_value"] : []
  # for_each            = var.enable_app_gateway ? toset(["any_value"]) : toset([])
  count               = var.enable_app_gateway ? 1 : 0
  name                = var.app_gateway
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = var.resources_location
  sku {
    name     = var.app_gateway_sku
    tier     = "Standard_v2"
    capacity = 2
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

  tags = var.tags

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

  depends_on = [azurerm_virtual_network.vnet_spoke, azurerm_public_ip.appgw_pip]
}

# # generated managed identity for app gateway
# data "azurerm_user_assigned_identity" "identity-appgw" {
#   name                = "ingressapplicationgateway-${var.aks_name}" # convention name for AGIC Identity
#   resource_group_name = var.node_resource_group

#   depends_on          = [azurerm_kubernetes_cluster.aks]
# }

# AppGW (generated with addon) Identity needs also Contributor role over AKS/VNET RG
resource "azurerm_role_assignment" "role-contributor" {
  count                = var.enable_app_gateway ? 1 : 0
  scope                = azurerm_resource_group.rg_aks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.0.ingress_application_gateway.0.ingress_application_gateway_identity.0.object_id
  # principal_id       = data.azurerm_user_assigned_identity.identity-appgw.principal_id

  # depends_on = [
  #   azurerm_kubernetes_cluster.aks,
  #   azurerm_application_gateway.appgw
  # ]
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_appgw" {
  count                      = var.enable_monitoring && var.enable_app_gateway ? 1 : 0
  name                       = "diagnostic-settings"
  target_resource_id         = azurerm_application_gateway.appgw.0.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}
