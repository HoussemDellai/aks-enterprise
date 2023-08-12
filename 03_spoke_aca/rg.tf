resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-aca"
  location = var.resources_location
  tags     = var.tags
}