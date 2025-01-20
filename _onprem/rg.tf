resource "azurerm_resource_group" "rg" {
  provider = azurerm.subscription_onprem
  name     = "rg-${var.prefix}-onpremise"
  location = var.location
  tags     = var.tags
}
