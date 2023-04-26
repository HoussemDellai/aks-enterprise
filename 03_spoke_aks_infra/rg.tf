resource "azurerm_resource_group" "rg_spoke_aks" {
  name     = "rg-spoke-aks-infra"
  location = var.resources_location
  tags     = var.tags
}