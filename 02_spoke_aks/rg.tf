resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-spoke-aks"
  location = var.location
  tags     = var.tags
}