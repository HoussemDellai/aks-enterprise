resource azurerm_resource_group" "rg_management" {
  provider = azurerm.subscription_hub
#   count    = var.enable_firewall || var.enable_bastion ? 1 : 0
  name     = "rg-management" # var.rg_hub
  location = var.resources_location
  tags     = var.tags
}