resource "azurerm_resource_group" "rg-dev" {
  name     = "rg-lzaks-spoke-aks-cx-dev"
  location = "swedencentral"
}

resource "azurerm_resource_group" "rg-prod" {
  name     = "rg-lzaks-spoke-aks-cx-prod"
  location = "swedencentral"
}

resource "azurerm_resource_group" "rg-monitoring" {
  name     = "rg-lzaks-spoke-aks-cx-monitoring"
  location = "swedencentral"
}