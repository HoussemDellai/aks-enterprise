module "virtual_network_peering_hub_and_spoke_app" {
  count         = var.enable_vnet_peering && (var.enable_firewall || var.enable_bastion) ? 1 : 0 #todo: add && var.enable_spoke_app
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = azurerm_virtual_network.vnet_hub.0.id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke_aks.id
}

module "virtual_network_peering_hub_and_spoke_mgt" {
  count         = var.enable_vnet_peering && (var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux) ? 1 : 0
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = azurerm_virtual_network.vnet_hub.0.id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke_mgt.0.id
}

module "virtual_network_peering_hub_and_spoke_appservice" {
  count         = var.enable_vnet_peering && var.enable_spoke_appservice ? 1 : 0
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = azurerm_virtual_network.vnet_hub.0.id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke_appservice.0.id
}