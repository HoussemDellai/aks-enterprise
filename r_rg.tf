resource "azurerm_resource_group" "rg_shared" {
  name     = var.resource_group_shared
  location = var.resources_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resources_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_hub" {
  provider = azurerm.subscription_hub
  name     = "rg_hub"
  location = var.resources_location

  tags = var.tags
}