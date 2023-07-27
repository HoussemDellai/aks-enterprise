resource "azurerm_route_table" "route_table_spoke_aks" {
  count                         = var.enable_firewall_as_dns_server ? 1 : 0
  name                          = "route-table-spoke-aks"
  location                      = azurerm_resource_group.rg_spoke_aks_cluster.location
  resource_group_name           = azurerm_resource_group.rg_spoke_aks_cluster.name
  disable_bgp_route_propagation = true
  tags                          = var.tags
}

resource "azurerm_route" "route_to_firewall" {
  # provider               = azurerm.subscription_hub
  count                  = var.enable_firewall_as_dns_server ? 1 : 0
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_route_table.route_table_spoke_aks.0.resource_group_name
  route_table_name       = azurerm_route_table.route_table_spoke_aks.0.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance" # "VirtualNetworkGateway"
  next_hop_in_ip_address = data.terraform_remote_state.hub.0.outputs.firewall.private_ip
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_system_nodes" {
  count          = var.enable_firewall_as_dns_server ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_nodes.id
  route_table_id = azurerm_route_table.route_table_spoke_aks.0.id
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_system_pods" {
  count          = var.enable_firewall_as_dns_server ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_pods.id
  route_table_id = azurerm_route_table.route_table_spoke_aks.0.id
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_nodes" {
  for_each       = var.enable_firewall_as_dns_server ? azurerm_subnet.subnet_nodes_user_nodepool : {}
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.route_table_spoke_aks.0.id
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_pods" {
  for_each       = var.enable_firewall_as_dns_server ? azurerm_subnet.subnet_pods_user_nodepool : {}
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.route_table_spoke_aks.0.id
}
