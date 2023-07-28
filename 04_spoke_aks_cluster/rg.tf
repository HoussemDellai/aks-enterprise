resource "azurerm_resource_group" "rg" {
  location = var.resources_location
  name     = "rg-${var.prefix}-cluster"
  tags     = var.tags
}