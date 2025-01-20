resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${var.prefix}-spoke-aks-cluster-airbus"
  tags     = var.tags
}