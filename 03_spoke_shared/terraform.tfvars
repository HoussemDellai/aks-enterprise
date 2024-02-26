# prefix = "demo011"
subscription_id_spoke                       = "38977b70-47bf-4da5-a492-88712fce8725" # "17b12858-3960-4e6f-a663-a06fdae23428"
subscription_id_hub                         = "38977b70-47bf-4da5-a492-88712fce8725" # "17b12858-3960-4e6f-a663-a06fdae23428"
tenant_id_hub                               = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4" # "558506eb-9459-4ef3-b920-ad55c555e729"
tenant_id_spoke                             = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4" # "558506eb-9459-4ef3-b920-ad55c555e729"
rg_hub                                      = "rg-hub"
rg_spoke_app                                = "rg-spoke-app"
rg_spoke_mgt                                = "rg-spoke-mgt"
rg_spoke_aks                                = "rg-spoke-aks"
rg_spoke_aks_nodes                          = "rg-spoke-aks-nodes"
rg_spoke_shared                             = "rg-spoke-shared"
rg_network_watcher                          = "NetworkWatcherRG"
resources_location                          = "swedencentral" # "francecentral" # "westcentralus" # 
acr_name                                    = "acrforakstf013"
keyvault_name                               = "kvforaks0113"
storage_account_name                        = "storageforaks011"
log_analytics_workspace                     = "loganalyticsforaks011"
kubernetes_version                          = "1.25.5" # "1.24.6" # 
aks_network_plugin                          = "azure"  # "kubenet", "none"
aad_group_aks_admins                        = "aad_group_aks_admins"
cidr_vnet_hub                               = ["172.16.0.0/16"]
cidr_subnet_firewall                        = ["172.16.0.0/26"]
cidr_subnet_bastion                         = ["172.16.1.0/27"]
cidr_vnet_spoke_aks                         = ["10.1.0.0/16"]
cidr_subnet_appgateway                      = ["10.1.1.0/24"]
cidr_subnet_spoke_aks_pe                    = ["10.1.2.0/28"]
cidr_subnet_nodes                           = ["10.1.3.0/24"]
cidr_subnet_apiserver_vnetint               = ["10.1.4.0/28"]
cidr_subnet_pods                            = ["10.1.240.0/20"]
cidr_vnet_spoke_mgt                         = ["10.2.0.0/16"]
cidr_subnet_mgt                             = ["10.2.0.0/24"]
cidr_vnet_spoke_appservice                  = ["10.3.0.0/16"]
cidr_vnet_spoke_shared                      = ["10.4.0.0/16"]
cidr_subnet_shared                          = ["10.4.0.0/24"]
cidr_aks_service                            = "10.0.0.0/16"
cidr_aks_docker_bridge                      = "172.17.0.1/16"
aks_dns_service_ip                          = "10.0.0.10"
aks_outbound_type                           = "loadBalancer" # "userAssignedNATGateway" # "loadBalancer" , userDefinedRouting, managedNATGateway
enable_app_gateway                          = false
enable_aks_cluster                          = true
enable_private_cluster                      = false
enable_apiserver_vnet_integration           = true
enable_nodepool_apps                        = true
enable_nodepool_spot                        = false
enable_system_nodepool_only_critical_addons = false
enable_aks_admin_group                      = false
enable_aks_admin_rbac                       = true
enable_private_acr                          = true
enable_keyvault                             = true
enable_private_keyvault                     = true
enable_bastion                              = true
enable_firewall                             = true
enable_vm_jumpbox_windows                   = false
enable_vm_jumpbox_linux                     = true
enable_spoke_appservice                     = false
enable_storage_account                      = true
enable_vnet_peering                         = true
enable_monitoring                           = true
enable_nsg_flow_logs                        = true
enable_diagnostic_settings                  = false
enable_diagnostic_settings_output           = false
enable_fleet_manager                        = false
enable_mysql_flexible_server                = true
enable_spoke_serverless                     = false
enable_grafana_prometheus                   = true
