prefix = "lzaks-spoke-aks-infra"

tenant_id_hub       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4"
subscription_id_hub = "38977b70-47bf-4da5-a492-88712fce8725"

tenant_id_spoke       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4" # "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "38977b70-47bf-4da5-a492-88712fce8725" # "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location   = "swedencentral" # "francecentral" # "westcentralus" # 
acr_name             = "acrforakstf01357"
keyvault_name        = "kvforakslz1357"
storage_account_name = "storageforaks01357"

cidr_vnet_spoke_aks      = ["10.1.0.0/16"]
cidr_subnet_appgateway   = ["10.1.1.0/24"]
cidr_subnet_spoke_aks_pe = ["10.1.2.0/28"]

enable_grafana_prometheus    = true
enable_app_gateway           = false
enable_appgateway_containers = true
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
