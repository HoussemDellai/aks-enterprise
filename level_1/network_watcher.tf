# # Log collection components
# resource azurerm_storage_account" "network_log_data" {
#   count                    = var.enable_nsg_flow_logs ? 1 : 0
#   name                     = "storageforlogs011"
#   resource_group_name      = azurerm_resource_group.rg_network_watcher.0.name
#   location                 = var.resources_location
#   account_kind             = "StorageV2"
#   account_tier             = "Standard"
#   min_tls_version          = "TLS1_2"
#   account_replication_type = "LRS"
#   tags                     = var.tags
# }

# # The Network Watcher Instance & network log flow
# # There can only be one Network Watcher per subscription and region
# data "azurerm_network_watcher" "network_watcher_regional" {
#   name                = "NetworkWatcher_${var.resources_location}"
#   resource_group_name = azurerm_resource_group.rg_network_watcher.0.name
# }

# # resource azurerm_network_watcher" "network_watcher_regional" {
# #   count               = var.enable_nsg_flow_logs ? 1 : 0
# #   name                = "NetworkWatcher_${var.resources_location}"
# #   location            = var.resources_location
# #   resource_group_name = azurerm_resource_group.rg_network_watcher.0.name
# # }

# data "azurerm_resources" "nsg_flowlogs" {
#   type          = "Microsoft.Network/networkSecurityGroups"
#   required_tags = var.tags
# }

# module "azurerm_network_watcher_flow_log" {
#   count                     = var.enable_nsg_flow_logs ? length(data.azurerm_resources.nsg_flowlogs.resources) : 0
#   source                    = "./modules/azurerm_network_watcher_flow_log"
#   nsg_name                  = data.azurerm_resources.nsg_flowlogs.resources[count.index].name
#   network_watcher_name      = data.azurerm_network_watcher.network_watcher_regional.name
#   resource_group_name       = data.azurerm_network_watcher.network_watcher_regional.resource_group_name
#   network_security_group_id = data.azurerm_resources.nsg_flowlogs.resources[count.index].id
#   storage_account_id        = azurerm_storage_account.network_log_data.0.id

#   workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
#   workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
#   workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
# }

# output "azurerm_resources_nsg_flowlogs" {
#   value = data.azurerm_resources.nsg_flowlogs.resources[*].name
# }

# # resource azurerm_network_watcher_flow_log" "network_flow_logs_nsg_subnet_mgt" {
# #   count                     = var.enable_nsg_flow_logs && var.enable_monitoring && (var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux) ? 1 : 0
# #   name                      = "network_flow_logs_nsg_subnet_mgt"
# #   network_watcher_name      = azurerm_network_watcher.network_watcher_regional.0.name
# #   resource_group_name       = azurerm_network_watcher.network_watcher_regional.0.resource_group_name
# #   network_security_group_id = azurerm_network_security_group.nsg_subnet_mgt.0.id
# #   storage_account_id        = azurerm_storage_account.network_log_data.0.id
# #   enabled                   = true
# #   version                   = 2

# #   retention_policy {
# #     enabled = true
# #     days    = 7
# #   }

# #   traffic_analytics {
# #     enabled               = true
# #     workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
# #     workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
# #     workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
# #     interval_in_minutes   = 10
# #   }
# # }

# # resource azurerm_network_watcher_flow_log" "network_flow_logs_nsg_subnet_appgw" {
# #   count                     = var.enable_nsg_flow_logs && var.enable_monitoring && var.enable_app_gateway ? 1 : 0
# #   name                      = "network_flow_logs_nsg_subnet_appgw"
# #   network_watcher_name      = azurerm_network_watcher.network_watcher_regional.0.name
# #   resource_group_name       = azurerm_network_watcher.network_watcher_regional.0.resource_group_name
# #   network_security_group_id = azurerm_network_security_group.nsg_subnet_appgw.0.id
# #   storage_account_id        = azurerm_storage_account.network_log_data.0.id
# #   enabled                   = true
# #   version                   = 2

# #   retention_policy {
# #     enabled = true
# #     days    = 7
# #   }

# #   traffic_analytics {
# #     enabled               = true
# #     workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
# #     workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
# #     workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
# #     interval_in_minutes   = 10
# #   }
# # }

# # resource azurerm_network_watcher_flow_log" "network_flow_logs_nsg_subnet_nodes" {
# #   count                     = var.enable_nsg_flow_logs && var.enable_monitoring && var.enable_aks_cluster ? 1 : 0
# #   name                      = "network_flow_logs_nsg_subnet_nodes"
# #   network_watcher_name      = azurerm_network_watcher.network_watcher_regional.0.name
# #   resource_group_name       = azurerm_network_watcher.network_watcher_regional.0.resource_group_name
# #   network_security_group_id = azurerm_network_security_group.nsg_subnet_nodes.0.id
# #   storage_account_id        = azurerm_storage_account.network_log_data.0.id
# #   enabled                   = true
# #   version                   = 2

# #   retention_policy {
# #     enabled = true
# #     days    = 7
# #   }

# #   traffic_analytics {
# #     enabled               = true
# #     workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
# #     workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
# #     workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
# #     interval_in_minutes   = 10
# #   }
# # }

# # resource azurerm_network_watcher_flow_log" "network_flow_logs_nsg_subnet_pods" {
# #   count                     = var.enable_nsg_flow_logs && var.enable_monitoring && var.enable_aks_cluster ? 1 : 0
# #   name                      = "network_flow_logs_nsg_subnet_pods"
# #   network_watcher_name      = azurerm_network_watcher.network_watcher_regional.0.name
# #   resource_group_name       = azurerm_network_watcher.network_watcher_regional.0.resource_group_name
# #   network_security_group_id = azurerm_network_security_group.nsg_subnet_pods.0.id
# #   storage_account_id        = azurerm_storage_account.network_log_data.0.id
# #   enabled                   = true
# #   version                   = 2

# #   retention_policy {
# #     enabled = true
# #     days    = 7
# #   }

# #   traffic_analytics {
# #     enabled               = true
# #     workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
# #     workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
# #     workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
# #     interval_in_minutes   = 10
# #   }
# # }

# # resource azurerm_network_watcher_flow_log" "network_flow_logs_nsg_subnet_vnet_integration" {
# #   count                     = var.enable_nsg_flow_logs && var.enable_monitoring && var.enable_spoke_appservice ? 1 : 0
# #   name                      = "network_flow_logs_nsg_subnet_vnet_integration"
# #   network_watcher_name      = azurerm_network_watcher.network_watcher_regional.0.name
# #   resource_group_name       = azurerm_network_watcher.network_watcher_regional.0.resource_group_name
# #   network_security_group_id = azurerm_network_security_group.nsg_subnet_vnet_integration.0.id
# #   storage_account_id        = azurerm_storage_account.network_log_data.0.id
# #   enabled                   = true
# #   version                   = 2

# #   retention_policy {
# #     enabled = true
# #     days    = 7
# #   }

# #   traffic_analytics {
# #     enabled               = true
# #     workspace_id          = azurerm_log_analytics_workspace.workspace.0.workspace_id
# #     workspace_region      = azurerm_log_analytics_workspace.workspace.0.location
# #     workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
# #     interval_in_minutes   = 10
# #   }
# # }

