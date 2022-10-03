#-----------------------------------------------------------------------------------------------------------------#
#   VNET PEERINGS
#   https://medium.com/microsoftazure/configure-azure-virtual-network-peerings-with-terraform-762b708a28d4                                                                       #
#-----------------------------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network_peering" "peering_vnet_aks_vnet_vm_jumpbox" {
  count                        = var.enable_vnet_peering ? 1 : 0
  name                         = "peering_vnet_aks_vnet_vm_jumpbox"
  resource_group_name          = azurerm_resource_group.rg_aks.name
  virtual_network_name         = azurerm_virtual_network.vnet_spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.0.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "peering_vnet_vm_jumpbox_vnet_aks" {
  count                        = var.enable_vnet_peering ? 1 : 0
  provider                     = azurerm.subscription_hub
  name                         = "peering_vnet_vm_jumpbox_vnet_aks"
  virtual_network_name         = azurerm_virtual_network.vnet_hub.0.name
  resource_group_name          = azurerm_virtual_network.vnet_hub.0.resource_group_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

# Needed for Jumpbox to resolve cluster URL using a private endpoint and private dns zone
resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_aks_vnet_vm_devbox" {
  count                 = var.enable_vnet_peering && var.enable_private_cluster ? 1 : 0
  name                  = "link_private_dns_aks_vnet_vm_devbox"
  resource_group_name   = azurerm_resource_group.rg_aks.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_aks.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.0.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link_to_vnet_hub_acr" {
  count                 = var.enable_vnet_peering && var.enable_private_acr ? 1 : 0
  provider              = azurerm.subscription_hub
  name                  = "link-p-dns-zone-acr-to-vnet-hub"
  resource_group_name   = azurerm_private_dns_zone.private_dns_zone_acr.0.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_acr.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.0.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link_to_vnet_hub_kv" {
  count                 = var.enable_vnet_peering && var.enable_private_keyvault && var.enable_keyvault ? 1 : 0
  name                  = "link-p-dns-zone-kv-to-vnet-hub"
  resource_group_name   = azurerm_resource_group.rg_aks.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_keyvault.0.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.0.id
}

#---------------------------------------------------------------------------------------#
#   PRIVATE DNS ZONE LINK (existing VNET)                                                    #
#---------------------------------------------------------------------------------------#

# data "azurerm_private_dns_zone" "private_dns_aks" {
# count               = var.enable_vnet_peering ? 1 : 0
#   name                = "01e40daf-b242-4075-a3ca-3a106e498f89.privatelink.westeurope.azmk8s.io"
#   resource_group_name = "rg-aks-cluster-managed"
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_aks_vnet_vm_devbox" {
#   count               = var.enable_vnet_peering ? 1 : 0
#   name                  = "link_private_dns_aks_vnet_vm_devbox"
#   resource_group_name   = "rg-aks-cluster-managed"
#   private_dns_zone_name = azurerm_private_dns_zone.private_dns_aks.name
#   virtual_network_id    = data.azurerm_virtual_network.vnet_hub.id
# }