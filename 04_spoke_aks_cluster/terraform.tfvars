prefix = "lzaks-spoke-aks"

tenant_id_hub       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_hub = "dcef7009-6b94-4382-afdc-17eb160d709a"

tenant_id_spoke       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_spoke = "dcef7009-6b94-4382-afdc-17eb160d709a"

resources_location = "swedencentral" # "francecentral" # "westcentralus" # "northeurope" # 

kubernetes_version   = "1.31.3"
aad_group_aks_admins = "aad_group_aks_admins"

cidr_subnet_system_nodes      = ["10.1.3.0/24"]
cidr_subnet_apiserver_vnetint = ["10.1.4.0/28"]
cidr_subnet_system_pods       = ["10.1.240.0/20"]

cidr_aks_service   = "10.0.0.0/16"
aks_dns_service_ip = "10.0.0.10"
aks_outbound_type  = "userDefinedRouting" # "userAssignedNATGateway" # "loadBalancer" , userDefinedRouting, managedNATGateway

aks_network_plugin  = "azure" # "kubenet", "none"
network_plugin_mode = null    # "overlay"

# AKS configuration
enable_app_gateway                          = false
enable_private_cluster                      = false
enable_apiserver_vnet_integration           = false
enable_nodepool_apps                        = true
enable_nodepool_spot                        = false
enable_system_nodepool_only_critical_addons = false
enable_aks_admin_group                      = true
enable_aks_admin_rbac                       = true
enable_maintenance_window                   = false

# monitoring
enable_grafana_prometheus = true
enable_monitoring         = true

# integration with Hub network
enable_hub_spoke                 = true
enable_route_traffic_to_firewall = true
enable_firewall_as_dns_server    = false
