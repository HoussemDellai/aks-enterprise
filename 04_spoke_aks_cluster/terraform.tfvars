prefix = "lzaks-spoke-aks"

tenant_id_hub       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4"
subscription_id_hub = "38977b70-47bf-4da5-a492-88712fce8725"

tenant_id_spoke       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4" # "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "38977b70-47bf-4da5-a492-88712fce8725" # "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location = "swedencentral" # "francecentral" # "westcentralus" # "northeurope" # 

kubernetes_version   = "1.27.3" # "1.26.3" # "1.26.0"
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
enable_aks_admin_group                      = false
enable_aks_admin_rbac                       = true
enable_maintenance_window                   = false

# monitoring
enable_grafana_prometheus = true
enable_monitoring         = true

# integration with Hub network
enable_hub_spoke                 = true
enable_route_traffic_to_firewall = true
enable_firewall_as_dns_server    = false
