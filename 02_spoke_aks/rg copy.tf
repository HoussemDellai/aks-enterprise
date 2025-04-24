resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${var.prefix}-spoke-aks-cluster"
  tags     = var.tags
}