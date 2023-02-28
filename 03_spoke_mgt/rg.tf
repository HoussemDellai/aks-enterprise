resource azurerm_resource_group" "rg_spoke_mgt" {
  name     = var.rg_spoke_mgt
  location = var.resources_location
  tags     = var.tags
}