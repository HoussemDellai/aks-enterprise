module "virtual_network_peering_hub_and_spoke_aks" {
  source        = "../modules/azurerm_virtual_network_peering"
  vnet_hub_id   = data.terraform_remote_state.hub.outputs.vnet_hub.id
  vnet_spoke_id = azurerm_virtual_network.vnet_spoke.id
}