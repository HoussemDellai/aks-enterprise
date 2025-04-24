resource "azurerm_application_load_balancer" "agc" {
  count               = var.enable_appgateway_containers ? 1 : 0
  name                = "agc-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_application_load_balancer_subnet_association" "agc-snet-association" {
  count                        = var.enable_appgateway_containers ? 1 : 0
  name                         = "agc-snet-association"
  application_load_balancer_id = azurerm_application_load_balancer.agc.0.id
  subnet_id                    = azurerm_subnet.snet_agc.0.id
}

resource "azurerm_application_load_balancer_frontend" "agc" {
  count                        = var.enable_appgateway_containers ? 1 : 0
  name                         = "agc-frontend"
  application_load_balancer_id = azurerm_application_load_balancer.agc.0.id
}
