resource azurerm_resource_group" "rg_hub" {
  provider = azurerm.subscription_hub
#   count    = var.enable_firewall || var.enable_bastion ? 1 : 0
  name     = var.rg_hub
  location = var.resources_location
  tags     = var.tags
}