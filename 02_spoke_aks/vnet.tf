resource "azurerm_virtual_network" "vnet_spoke_aks" {
  name                = "vnet-spoke-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.cidr_vnet_spoke_aks
  dns_servers         = var.enable_hub_spoke && var.enable_firewall_as_dns_server ? [data.terraform_remote_state.hub.0.outputs.firewall.private_ip] : null
  tags                = var.tags
}

resource "azurerm_subnet" "snet_aks" {
  name                 = "snet-aks"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_snet_aks
}

resource "azurerm_subnet" "snet_pe" {
  count                = var.enable_private_acr || var.enable_private_keyvault ? 1 : 0
  name                 = "snet-pe"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_snet_pe
}

resource "azurerm_subnet" "snet_agc" {
  count                = var.enable_appgateway_containers ? 1 : 0
  name                 = "snet-agc"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_snet_agc

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.ServiceNetworking/trafficControllers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
resource "azurerm_subnet" "snet_appgw" {
  count                = var.enable_app_gateway ? 1 : 0
  name                 = "snet-appgw"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_snet_app_gateway
}

# resource "azurerm_subnet" "snet_system_pods" {
#   name                 = "snet-pods"
#   virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name # azurerm_virtual_network.vnet_spoke_aks.name
#   resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name  # azurerm_virtual_network.vnet_spoke_aks.resource_group_name
#   address_prefixes     = var.cidr_subnet_system_pods

#   # src: https://github.com/hashicorp/terraform-provider-azurerm/blob/4ea5f92ccc27a75807d704f6d66d53a6c31459cb/internal/services/containers/kubernetes_cluster_node_pool_resource_test.go#L1433
#   delegation {
#     name = "Microsoft.ContainerService.managedClusters"
#     service_delegation {
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#       name = "Microsoft.ContainerService/managedClusters"
#     }
#   }
# }

# resource "azurerm_subnet" "snet_apiserver" {
#   count                = var.enable_apiserver_vnet_integration ? 1 : 0
#   name                 = "snet-apiserver"
#   virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name
#   resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name
#   address_prefixes     = var.cidr_subnet_apiserver_vnetint

#   delegation {
#     name = "Microsoft.ContainerService.managedClusters"
#     service_delegation {
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#       name = "Microsoft.ContainerService/managedClusters"
#     }
#   }
# }