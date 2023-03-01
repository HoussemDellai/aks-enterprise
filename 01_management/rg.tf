resource "azurerm_resource_group" "rg_management" {
  provider = azurerm.subscription_hub
  name     = "rg-management" # var.rg_hub
  location = var.resources_location
  tags     = var.tags
}
