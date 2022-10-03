resource "azurerm_resource_group" "rg_spoke" {
  name     = var.rg_spoke
  location = var.resources_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_aks" {
  name     = var.rg_aks
  location = var.resources_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_hub" {
  provider = azurerm.subscription_hub
  name     = var.rg_hub
  location = var.resources_location

  tags = var.tags
}