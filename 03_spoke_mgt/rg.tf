resource azurerm_resource_group rg_spoke_mgt {
  name     = "rg-spoke-mgt"
  location = var.resources_location
  tags     = var.tags
}