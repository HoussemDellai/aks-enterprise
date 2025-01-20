resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-aca"
  location = var.location
  tags     = var.tags
}