resource "azurerm_resource_group" "rg" {
  provider = azurerm.subscription_onprem
  name     = "rg-${var.prefix}-onpremise"
  location = var.resources_location
  tags     = var.tags
}
