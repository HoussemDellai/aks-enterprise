resource "azurerm_resource_group" "rg" {
  provider = azurerm.subscription_hub
  name     = "rg-hub"
  location = var.location
  tags     = var.tags
}