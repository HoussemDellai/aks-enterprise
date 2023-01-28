resource "azurerm_virtual_network" "vnet_spoke_app" {
  name                = "vnet-spoke-app"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_app.name
  address_space       = var.cidr_vnet_spoke_app
  dns_servers         = var.enable_firewall ? [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address] : null
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_nodes" {
  name                 = "subnet-nodes"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = var.cidr_subnet_nodes
}

resource "azurerm_subnet" "subnet_pods" {
  name                 = "subnet-pods"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = var.cidr_subnet_pods

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

resource "azurerm_subnet" "subnet_appgw" {
  count                = var.enable_app_gateway ? 1 : 0
  name                 = "subnet-appgw"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = var.cidr_subnet_appgateway
}

resource "azurerm_subnet" "subnet_apiserver" {
  count                = var.enable_apiserver_vnet_integration ? 1 : 0
  name                 = "subnet-apiserver"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = var.cidr_subnet_apiserver_vnetint

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

resource "azurerm_subnet" "subnet_pe" {
  count                = var.enable_private_acr || var.enable_private_keyvault ? 1 : 0
  name                 = "subnet-pe"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = var.cidr_subnet_pe
}

resource "azurerm_network_security_group" "nsg_subnet_nodes" {
  count               = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
  name                = "nsg_subnet_nodes"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  tags                = var.tags

  # security_rule {
  #   name                       = "rule_subnet_nodes"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
}

resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_nodes" {
  count                     = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet_nodes.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_nodes.0.id
}

resource "azurerm_network_security_group" "nsg_subnet_pods" {
  count               = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
  name                = "nsg_subnet_pods"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  tags                = var.tags

  # security_rule {
  #   name                       = "rule_subnet_pods"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
}

resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_pods" {
  count                     = var.enable_aks_cluster && var.enable_nsg_flow_logs ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet_pods.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_pods.0.id
}

resource "azurerm_network_security_group" "nsg_subnet_appgw" {
  count               = var.enable_app_gateway && var.enable_nsg_flow_logs ? 1 : 0
  name                = "nsg_subnet_appgw"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  tags                = var.tags

  # security_rule {
  #   name                       = "rule_subnet_appgw"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
}

resource "azurerm_subnet_network_security_group_association" "association_nsg_subnet_appgw" {
  count                     = var.enable_app_gateway && var.enable_nsg_flow_logs ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet_appgw.0.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_appgw.0.id
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_nodes" {
  count          = var.enable_aks_cluster && var.enable_firewall ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_nodes.id
  route_table_id = azurerm_route_table.route_table_to_firewall.id
}

resource "azurerm_subnet_route_table_association" "association_route_table_subnet_pods" {
  count          = var.enable_aks_cluster && var.enable_firewall ? 1 : 0
  subnet_id      = azurerm_subnet.subnet_pods.id
  route_table_id = azurerm_route_table.route_table_to_firewall.id
}