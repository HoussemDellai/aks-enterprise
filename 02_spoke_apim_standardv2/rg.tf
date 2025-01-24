resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-spoke-apim-weu"
  location = var.location
  tags     = var.tags
}