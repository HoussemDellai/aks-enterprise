resource "azurerm_resource_group" "rg_spoke_aks_cluster" {
  location = var.resources_location
  name     = "rg-${var.prefix}-spoke-aks-cluster"
  tags     = var.tags
}