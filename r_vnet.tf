resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  tags = var.tags
}

resource "azurerm_subnet" "subnet_nodes" {
  name                 = var.subnet_nodes_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.subnet_nodes_address_prefix
}

resource "azurerm_subnet" "subnet_pods" {
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

resource "azurerm_subnet" "subnet_appgw" {
  count                = var.enable_application_gateway ? 1 : 0
  name                 = var.app_gateway_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.app_gateway_subnet_address_prefix
}

resource "azurerm_subnet" "subnet_apiserver" {
  count                = var.enable_apiserver_vnet_integration ? 1 : 0
  name                 = var.apiserver_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.apiserver_subnet_address_prefix

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
  name                 = var.app_gateway_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.pe_subnet_address_prefix
}

# resource "azurerm_monitor_diagnostic_setting" "vnet_one_diagnostics_settings" {
#   name                       = "diagnostics-settings"
#   target_resource_id         = module.network_one.vnet_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace_one.id

#   log {
#     category = "VMProtectionAlerts"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = true
#     }
#   }
# }