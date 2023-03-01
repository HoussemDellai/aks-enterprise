resource "azurerm_resource_group" "rg_spoke_aks" {
  name     = var.rg_spoke_aks
  location = var.resources_location
  tags     = var.tags
}