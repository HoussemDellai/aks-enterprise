resource "azurerm_resource_group" "rg_spoke_shared" {
  name     = var.rg_spoke_shared
  location = var.location
  tags     = var.tags
}