resource azurerm_virtual_network" "vnet_hub" {
  provider            = azurerm.subscription_hub
#   count               = var.enable_firewall || var.enable_bastion ? 1 : 0
  name                = "vnet-hub"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.resources_location
  address_space       = var.cidr_vnet_hub
  tags                = var.tags
}

output "vnet_hub_id" {
  value = azurerm_virtual_network.vnet_hub.id
}