module "virtual_network_peering_hub_and_spoke_aks" {
  count         = var.enable_vnet_peering ? 1 : 0 #todo: add && var.enable_spoke_app
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = data.terraform_remote_state.hub.0.outputs.vnet_hub.id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke_aks.id
}