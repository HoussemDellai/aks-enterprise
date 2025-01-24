resource "azurerm_public_ip" "pip-apim" {
  name                = "pip-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"] # ["1", "2", "3"]
  domain_name_label   = "apim-internal-${var.prefix}"
}
