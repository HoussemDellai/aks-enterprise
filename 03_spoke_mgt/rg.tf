resource azurerm_resource_group rg_spoke_mgt {
  name     = "rg-${var.prefix}-spoke-mgt"
  location = var.resources_location
  tags     = var.tags
}