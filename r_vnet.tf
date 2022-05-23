resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resources_location
}

# --------------------------------------------------------------------------------------------------------------------------
# HUB VNET
# --------------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnet-hub" {
  name                = var.virtual_network_name_hub
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix_hub]

  tags = var.tags
}

resource "azurerm_subnet" "subnetappgw" {
  name                 = var.app_gateway_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.app_gateway_subnet_address_prefix
}

# --------------------------------------------------------------------------------------------------------------------------
# SPOKE VNET (AKS)
# --------------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnet-spoke" {
  name                = var.virtual_network_name_spoke
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix_spoke]

  tags = var.tags
}

resource "azurerm_subnet" "subnetnodes" {
  name                 = var.subnet_nodes_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.subnet_nodes_address_prefix
}

resource "azurerm_subnet" "subnetpods" {
  name                 = var.subnet_pods_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
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

# --------------------------------------------------------------------------------------------------------------------------
# VNET PEERING (HUB-SPOKE)
# --------------------------------------------------------------------------------------------------------------------------
