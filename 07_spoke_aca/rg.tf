resource azurerm_resource_group" "rg_spoke_aca" {
  #   count    = var.enable_spoke_appservice ? 1 : 0
  name     = "rg-spoke-aca"
  location = var.resources_location
  tags     = var.tags
}