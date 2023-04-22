resource "azurerm_resource_group" "rg_spoke_aks_cluster" {
  location = var.resources_location
  name     = "rg-spoke-aks-cluster"
  tags     = var.tags
}