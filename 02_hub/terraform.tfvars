prefix = "lzaks-hub-weu"

tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

tenant_id_spoke       = "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location = "westeurope" # "francecentral" # "westcentralus" # 

cidr_vnet_hub        = ["172.16.0.0/16"]
cidr_subnet_firewall = ["172.16.0.0/26"]
cidr_subnet_bastion  = ["172.16.1.0/27"]
cidr_subnet_vm       = ["172.16.2.0/26"]

enable_bastion  = true
enable_firewall = true

enable_vm_jumpbox_linux = true
enable_vm_jumpbox_windows = false