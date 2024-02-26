prefix = "lzaks-spoke-mgt-eus"

tenant_id_hub       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4"
subscription_id_hub = "38977b70-47bf-4da5-a492-88712fce8725"

tenant_id_spoke       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4" # "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "38977b70-47bf-4da5-a492-88712fce8725" # "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location = "eastus"

cidr_vnet_spoke_mgt = ["10.20.0.0/16"]
cidr_subnet_mgt     = ["10.20.0.0/24"]

enable_vm_jumpbox_windows = false
enable_vm_jumpbox_linux   = true

# integration with Hub & Firewall
enable_firewall_as_dns_server = true
enable_hub_spoke           = true
