resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-aks-simple"
  location = "swedencentral"
}