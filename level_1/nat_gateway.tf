resource azurerm_public_ip natgw_pip {
  count               = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? 1 : 0
  name                = "public-ip-nat-gateway"
  location            = azurerm_resource_group.rg_spoke_aks.location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource azurerm_public_ip_prefix natgw_ip_prefix {
  count               = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? 1 : 0
  name                = "public-ip-prefix-nat-gateway"
  location            = azurerm_resource_group.rg_spoke_aks.location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  prefix_length       = 30
  zones               = ["1"]
}

resource azurerm_nat_gateway natgw {
  count                   = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? 1 : 0
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg_spoke_aks.location
  resource_group_name     = azurerm_resource_group.rg_spoke_aks.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource azurerm_nat_gateway_public_ip_association pip_assoc {
  count                = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.natgw.0.id
  public_ip_address_id = azurerm_public_ip.natgw_pip.0.id
}

resource azurerm_subnet_nat_gateway_association subnetnodes_assoc {
  count          = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? 1 : 0
  nat_gateway_id = azurerm_nat_gateway.natgw.0.id
  subnet_id      = azurerm_subnet.subnet_nodes.id
}

resource azurerm_subnet_nat_gateway_association subnetpods_assoc {
  count          = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? 1 : 0
  nat_gateway_id = azurerm_nat_gateway.natgw.0.id
  subnet_id      = azurerm_subnet.subnet_pods.id
}

resource azurerm_subnet_nat_gateway_association subnetappgw_assoc {
  count          = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" && var.enable_app_gateway ? 1 : 0
  nat_gateway_id = azurerm_nat_gateway.natgw.0.id
  subnet_id      = azurerm_subnet.subnet_appgw.0.id
}