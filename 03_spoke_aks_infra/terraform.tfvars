# prefix = "demo011"
tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location                          = "westeurope" # "francecentral" # "westcentralus" # 
acr_name                                    = "acrforakstf01357"
keyvault_name                               = "kvforaks01357"
storage_account_name                        = "storageforaks01357"

cidr_vnet_spoke_aks                         = ["10.1.0.0/16"]
cidr_subnet_appgateway                      = ["10.1.1.0/24"]
cidr_subnet_spoke_aks_pe                    = ["10.1.2.0/28"]

enable_grafana_prometheus                   = true
enable_app_gateway  = true
enable_keyvault                             = true
enable_storage_account                      = true
enable_private_keyvault                     = true
enable_private_acr                          = true

enable_monitoring   = true

# integration with Hub & Firewall
enable_hub_spoke    = true
enable_firewall     = true
enable_vnet_peering = true