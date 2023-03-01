resource azurerm_resource_group rg_spoke_appservice {
  #   count    = var.enable_spoke_appservice ? 1 : 0
  name     = "rg-spoke-appservice"
  location = var.resources_location
  tags     = var.tags
}