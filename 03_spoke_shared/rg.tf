resource azurerm_resource_group rg_spoke_shared {
  name     = var.rg_spoke_shared
  location = var.resources_location
  tags     = var.tags
}