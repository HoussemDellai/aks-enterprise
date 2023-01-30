resource "azurerm_subnet" "subnet_pe" {
  count                = var.enable_private_acr || var.enable_private_keyvault ? 1 : 0
  name                 = "subnet-pe"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = var.cidr_subnet_pe
}

# resource "azurerm_network_security_group" "nsg_subnet_nodes" {
#   count               = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
#   name                = "nsg_subnet_nodes"
#   location            = var.resources_location
#   resource_group_name = azurerm_resource_group.rg_spoke_aks.name
#   tags                = var.tags
# }

# resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_nodes" {
#   count                     = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
#   subnet_id                 = azurerm_subnet.subnet_nodes.id
#   network_security_group_id = azurerm_network_security_group.nsg_subnet_nodes.0.id
# }

# resource "azurerm_network_security_group" "nsg_subnet_pods" {
#   count               = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
#   name                = "nsg_subnet_pods"
#   location            = var.resources_location
#   resource_group_name = azurerm_resource_group.rg_spoke_aks.name
#   tags                = var.tags
# }

# resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_pods" {
#   count                     = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
#   subnet_id                 = azurerm_subnet.subnet_pods.id
#   network_security_group_id = azurerm_network_security_group.nsg_subnet_pods.0.id
# }

# resource "azurerm_network_security_group" "nsg_subnet_appgw" {
#   count               = var.enable_app_gateway && var.enable_nsg_flow_logs ? 1 : 0
#   name                = "nsg_subnet_appgw"
#   location            = var.resources_location
#   resource_group_name = azurerm_resource_group.rg_spoke_aks.name
#   tags                = var.tags
# }

# resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_appgw" {
#   count                     = var.enable_app_gateway && var.enable_nsg_flow_logs ? 1 : 0
#   subnet_id                 = azurerm_subnet.subnet_appgw.0.id
#   network_security_group_id = azurerm_network_security_group.nsg_subnet_appgw.0.id
# }

# resource "azurerm_subnet_route_table_association" "association_route_table_subnet_nodes" {
#   count          = var.enable_aks_cluster && var.enable_firewall ? 1 : 0
#   subnet_id      = azurerm_subnet.subnet_nodes.id
#   route_table_id = azurerm_route_table.route_table_to_firewall.id
# }

# resource "azurerm_subnet_route_table_association" "association_route_table_subnet_pods" {
#   count          = var.enable_aks_cluster && var.enable_firewall ? 1 : 0
#   subnet_id      = azurerm_subnet.subnet_pods.id
#   route_table_id = azurerm_route_table.route_table_to_firewall.id
# }