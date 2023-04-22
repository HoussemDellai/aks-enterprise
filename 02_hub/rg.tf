resource "azurerm_resource_group" "rg_hub" {
  provider = azurerm.subscription_hub
  name     = "rg-hub"
  location = var.resources_location
  tags     = var.tags
}