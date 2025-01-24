resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-spoke-apim-weu-portal"
  location = var.location
  tags     = var.tags
}