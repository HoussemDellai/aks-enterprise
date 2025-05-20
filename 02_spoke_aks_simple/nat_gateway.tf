resource "azurerm_nat_gateway" "nat-gateway" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"] # Only one AZ can be defined.
}

resource "azurerm_subnet_nat_gateway_association" "association" {
  subnet_id      = azurerm_subnet.snet_aks.id
  nat_gateway_id = azurerm_nat_gateway.nat-gateway.id
}
