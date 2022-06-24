resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resources_location

  tags = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  tags = var.tags
}

resource "azurerm_subnet" "subnetnodes" {
  name                 = var.subnet_nodes_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.subnet_nodes_address_prefix
}

resource "azurerm_subnet" "subnetpods" {
  name                 = var.subnet_pods_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.subnet_pods_address_prefix

  # src: https://github.com/hashicorp/terraform-provider-azurerm/blob/4ea5f92ccc27a75807d704f6d66d53a6c31459cb/internal/services/containers/kubernetes_cluster_node_pool_resource_test.go#L1433
  delegation {
    name = "aks-delegation"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_subnet" "subnetappgw" {
  name                 = var.app_gateway_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.app_gateway_subnet_address_prefix
}

#-----------------------------------------------------------------------------------------------------------------#
#   VNET PEERINGS
#   https://medium.com/microsoftazure/configure-azure-virtual-network-peerings-with-terraform-762b708a28d4                                                                       #
#-----------------------------------------------------------------------------------------------------------------#

data "azurerm_virtual_network" "vnet_vm_jumpbox" {
  provider            = azurerm.ms-internal
  name                = "rg-vm-devbox-vnet"
  resource_group_name = "rg-vm-devbox"
}

resource "azurerm_virtual_network_peering" "peering_vnet_aks_vnet_vm_jumpbox" {
  name                         = "peering_vnet_aks_vnet_vm_jumpbox"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet_vm_jumpbox.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

resource "azurerm_virtual_network_peering" "peering_vnet_vm_jumpbox_vnet_aks" {
  provider                     = azurerm.ms-internal
  name                         = "peering_vnet_vm_jumpbox_vnet_aks"
  resource_group_name          = "rg-vm-devbox"
  virtual_network_name         = "rg-vm-devbox-vnet"
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # `allow_gateway_transit` must be set to false for vnet Global Peering
}

#---------------------------------------------------------------------------------------#
#   PRIVATE DNS ZONE LINK                                                               #
#---------------------------------------------------------------------------------------#

data "azurerm_private_dns_zone" "private_dns_aks" {
  name                = "01e40daf-b242-4075-a3ca-3a106e498f89.privatelink.westeurope.azmk8s.io"
  resource_group_name = "rg-aks-cluster-managed"
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_private_dns_aks_vnet_vm_devbox" {
  name                  = "link_private_dns_aks_vnet_vm_devbox"
  resource_group_name   = "rg-aks-cluster-managed"
  private_dns_zone_name = data.azurerm_private_dns_zone.private_dns_aks.name
  virtual_network_id    = data.azurerm_virtual_network.vnet_vm_jumpbox.id
}