resource "azurerm_public_ip" "pip_onprem_vpn_gateway" {
  provider            = azurerm.subscription_onprem
  name                = "pip-onprem-vpn-gateway1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vnet_vpn_gateway_onprem" {
  provider            = azurerm.subscription_onprem
  name                = "vnet-vpn-gateway-onprem"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_onprem_vpn_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_onprem_gateway.id
  }
  depends_on = [azurerm_public_ip.pip_onprem_vpn_gateway]
}