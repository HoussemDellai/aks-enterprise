resource "azurerm_resource_group" "rg_spoke_aks" {
  name     = "rg-${var.prefix}-spoke-aks-infra"
  location = var.resources_location
  tags     = var.tags
}