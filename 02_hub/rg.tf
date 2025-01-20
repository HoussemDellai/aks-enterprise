resource "azurerm_resource_group" "rg" {
  provider = azurerm.subscription_hub
  name     = "rg-${var.prefix}-hub"
  location = var.location
  tags     = var.tags
}