resource "azurerm_resource_group" "rg" {
  provider = azurerm.subscription_hub
  name     = "rg-${var.prefix}"
  location = var.resources_location
  tags     = var.tags
}