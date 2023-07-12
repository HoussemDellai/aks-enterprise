resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.resources_location
  tags     = var.tags
}