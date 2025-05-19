prefix   = "lzaks"
location = "swedencentral" # "francecentral" # "westcentralus" # 

tenant_id_hub       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_hub = "dcef7009-6b94-4382-afdc-17eb160d709a"

tenant_id_spoke       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_spoke = "dcef7009-6b94-4382-afdc-17eb160d709a"

acr_name             = "acrforakstf01357"
keyvault_name        = "kvforakslz1357"
storage_account_name = "storageforaks01357"

cidr_vnet_spoke_aks   = ["10.1.0.0/16"]
cidr_snet_app_gateway = ["10.1.1.0/24"]
cidr_snet_pe          = ["10.1.2.0/28"]
cidr_snet_agc         = ["10.1.3.0/24"]
cidr_snet_aks         = ["10.1.4.0/22"]

enable_grafana_prometheus    = true
enable_app_gateway           = false
enable_appgateway_containers = false
enable_keyvault              = false
enable_storage_account       = false
enable_private_keyvault      = false
enable_private_acr           = true

# enable_monitoring = false

# integration with Hub & Firewall
enable_hub_spoke                 = true
enable_route_traffic_to_firewall = true
enable_firewall_as_dns_server    = true
# enable_vnet_peering           = true

enable_aks_admin_group                      = false
enable_aks_admin_rbac                       = false
aad_group_aks_admins                        = "aad_group_aks_admins"
enable_private_cluster                      = false
kubernetes_version                          = "1.33.0"
enable_nodepool_spot                        = false
cidr_aks_pods                               = "10.0.0.0/17"
cidr_aks_service                            = "10.128.0.0/22"
aks_dns_service_ip                          = "10.128.0.10"
aks_outbound_type                           = "userDefinedRouting" # "userAssignedNATGateway" # "loadBalancer" , userDefinedRouting, managedNATGateway
enable_monitoring                           = false
enable_maintenance_window                   = false
aks_agent_os_disk_size                      = 40
enable_system_nodepool_only_critical_addons = false
