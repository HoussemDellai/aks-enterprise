prefix = "lzaks-spoke-mgt-eus"

tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location = "eastus"

cidr_vnet_spoke_mgt = ["10.20.0.0/16"]
cidr_subnet_mgt     = ["10.20.0.0/24"]

enable_vm_jumpbox_windows = false
enable_vm_jumpbox_linux   = true

# integration with Hub & Firewall
enable_firewall_as_dns_server = true
enable_hub_spoke           = true