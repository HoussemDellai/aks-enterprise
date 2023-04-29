resource "azurerm_resource_group" "rg_management" {
  provider = azurerm.subscription_hub
  name     = "rg-${var.prefix}-management"
  location = var.resources_location
  tags     = var.tags
}
