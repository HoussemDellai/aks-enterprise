# prefix = "demo041"
subscription_id_spoke             = "4b72ed90-7ca3-4e76-8d0f-31a2c0bee7a3" # "59d574d4-1c03-4092-ab22-312ed594eec9"
subscription_id_hub               = "4b72ed90-7ca3-4e76-8d0f-31a2c0bee7a3" # "59d574d4-1c03-4092-ab22-312ed594eec9"
tenant_id_hub                     = "72f988bf-86f1-41af-91ab-2d7cd011db47"
tenant_id_spoke                   = "72f988bf-86f1-41af-91ab-2d7cd011db47"
rg_hub                            = "rg-hub"
rg_spoke_app                      = "rg-spoke-app"
rg_spoke_mgt                      = "rg-spoke-mgt"
rg_spoke_aks                      = "rg-spoke-aks"
rg_spoke_aks_nodes                = "rg-spoke-aks-nodes"
resources_location                = "westeurope"
acr_name                          = "acrforakstf011"
keyvault_name                     = "kvforaks0111"
storage_account_name              = "storageforaks011"
log_analytics_workspace           = "loganalyticsforaks011"
kubernetes_version                = "1.24.6"
aks_network_plugin                = "azure" # "kubenet"
aad_group_aks_admins              = "group_aks_admins"
cidr_vnet_hub                     = ["172.16.0.0/16"]
cidr_subnet_firewall              = ["172.16.0.0/26"]
cidr_subnet_bastion               = ["172.16.1.0/27"]
cidr_vnet_spoke_app               = ["10.1.0.0/16"]
cidr_subnet_appgateway            = ["10.1.1.0/24"]
cidr_subnet_pe                    = ["10.1.2.0/28"]
cidr_subnet_nodes                 = ["10.1.3.0/24"]
cidr_subnet_pods                  = ["10.1.4.0/24"]
cidr_vnet_spoke_mgt               = ["10.2.0.0/16"]
cidr_subnet_mgt                   = ["10.2.0.0/24"]
cidr_aks_service                  = "10.0.0.0/16"
cidr_aks_docker_bridge            = "172.17.0.1/16"
aks_dns_service_ip                = "10.0.0.10"
aks_outbound_type                 = "userAssignedNATGateway" # "loadBalancer" # userDefinedRouting, managedNATGateway
enable_app_gateway                = true
enable_aks_cluster                = true
enable_private_cluster            = false
enable_vnet_peering               = true
enable_monitoring                 = true
enable_apiserver_vnet_integration = false # true           # 
enable_nodepool_apps              = false
enable_nodepool_spot              = false # false
enable_aks_admin_group            = false
enable_aks_admin_rbac             = true
enable_private_acr                = true
enable_keyvault                   = true
enable_private_keyvault           = true
enable_bastion                    = true
enable_firewall                   = true
enable_vm_jumpbox_windows         = false
enable_vm_jumpbox_linux           = true
enable_nsg_flow_logs              = true
# enable_velero_backups             = true
# aks_admin_group_object_ids        = ["1eb16a7c-42cc-49e3-8ff0-d179433be6a6"] # HoussemDellaiGroup
# storage_account_name_backup       = "storageforaksbackup001"
# backups_rg_name                   = "rg-aks-cluster-backups"
# backups_region                    = "northeurope"
