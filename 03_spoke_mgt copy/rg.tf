resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-spoke-mgt-wcus"
  location = var.resources_location
  tags     = var.tags
}