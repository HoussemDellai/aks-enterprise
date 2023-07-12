prefix = "lzaks"

tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location = "westeurope" # "francecentral" # "westcentralus" # 

cidr_vnet_spoke_mgt = ["10.2.0.0/16"]
cidr_subnet_mgt     = ["10.2.0.0/24"]

enable_vm_jumpbox_windows = true
enable_vm_jumpbox_linux   = false

# integration with Hub & Firewall
enable_firewall     = true
enable_vnet_peering = true