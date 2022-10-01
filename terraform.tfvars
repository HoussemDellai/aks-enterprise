# prefix = "demo041"
resource_group_name               = "rg-aks-cluster"
resource_group_shared             = "rg-shared"
node_resource_group               = "rg-aks-cluster-managed"
resources_location                = "westeurope" # "eastus2" # 
aks_name                          = "aks-cluster"
acr_name                          = "acrforakstf0111"
keyvault_name                     = "kvforaks0111"
kubernetes_version                = "1.24.3" # "1.24.0" # 
aks_network_plugin                = "azure"  # "azure", "kubenet"
spn_name                          = "spn-aks-tf"
aad_group_aks_admins              = "group_aks_admins"
virtual_network_address_prefix    = "10.0.0.0/8"
subnet_pods_address_prefix        = ["10.240.0.0/16"]
subnet_nodes_address_prefix       = ["10.241.0.0/24"]
app_gateway_subnet_address_prefix = ["10.1.0.0/16"]
pe_subnet_address_prefix = ["10.3.0.0/28"]
aks_service_cidr                  = "10.0.0.0/16"
aks_dns_service_ip                = "10.0.0.10"
aks_docker_bridge_cidr            = "172.17.0.1/16"
aks_outbound_type                 = "userAssignedNATGateway" # "loadBalancer" # "loadBalancer" # userDefinedRouting, managedNATGateway
log_analytics_workspace_name      = "loganalyticsakscluster"
enable_application_gateway        = true  # false # 
enable_private_cluster            = false # true  #
enable_vnet_peering               = false # true  # 
enable_container_insights         = true  #false          # 
enable_apiserver_vnet_integration = false # true           # 
enable_nodepool_apps              = false
enable_nodepool_spot              = true # false
enable_aks_admin_group            = false
enable_aks_admin_rbac             = true
enable_private_acr                = true
enable_private_keyvault           = true
# enable_velero_backups             = true
# aks_admin_group_object_ids        = ["1eb16a7c-42cc-49e3-8ff0-d179433be6a6"] # HoussemDellaiGroup
# storage_account_name_backup       = "storageforaksbackup001"
# backups_rg_name                   = "rg-aks-cluster-backups"
# backups_region                    = "northeurope"