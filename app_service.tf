# resource "azurerm_resource_group" "rg" {
#   name     = "appservice-rg"
#   location = "francecentral"
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "vnet"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "integrationsubnet" {
#   name                 = "integrationsubnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
#   delegation {
#     name = "delegation"
#     service_delegation {
#       name = "Microsoft.Web/serverFarms"
#     }
#   }
# }

# resource "azurerm_subnet" "endpointsubnet" {
#   name                                           = "endpointsubnet"
#   resource_group_name                            = azurerm_resource_group.rg.name
#   virtual_network_name                           = azurerm_virtual_network.vnet.name
#   address_prefixes                               = ["10.0.2.0/24"]
#   private_endpoint_network_policies_enabled = true
# }

# resource "azurerm_app_service_plan" "appserviceplan" {
#   name                = "appserviceplan"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   sku {
#     tier = "Premiumv2"
#     size = "P1v2"
#   }
# }

# resource "azurerm_app_service" "frontwebapp" {
#   name                = "frontwebapp011"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

#   app_settings = {
#     "WEBSITE_DNS_SERVER" : "168.63.129.16",
#     "WEBSITE_VNET_ROUTE_ALL" : "1"
#   }
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
#   app_service_id = azurerm_app_service.frontwebapp.id
#   subnet_id      = azurerm_subnet.integrationsubnet.id
# }

# resource "azurerm_app_service" "backwebapp" {
#   name                = "backwebapp011"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
# }

# resource "azurerm_private_dns_zone" "dnsprivatezone" {
#   name                = "privatelink.azurewebsites.net"
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
#   name                  = "dnszonelink"
#   resource_group_name   = azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone.name
#   virtual_network_id    = azurerm_virtual_network.vnet.id
# }

# resource "azurerm_private_endpoint" "privateendpoint" {
#   name                = "backwebappprivateendpoint"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.endpointsubnet.id

#   private_dns_zone_group {
#     name                 = "privatednszonegroup"
#     private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
#   }

#   private_service_connection {
#     name                           = "privateendpointconnection"
#     private_connection_resource_id = azurerm_app_service.backwebapp.id
#     subresource_names              = ["sites"]
#     is_manual_connection           = false
#   }
# }