prefix   = "alz"
location = "swedencentral" # "francecentral" # "westcentralus" # 

tenant_id_hub       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_hub = "dcef7009-6b94-4382-afdc-17eb160d709a"

tenant_id_spoke       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_spoke = "dcef7009-6b94-4382-afdc-17eb160d709a"

cidr_vnet_hub             = ["172.16.0.0/16"]
cidr_subnet_firewall      = ["172.16.0.0/26"]
cidr_subnet_firewall_mgmt = ["172.16.3.0/26"]
cidr_subnet_bastion       = ["172.16.1.0/27"]
cidr_subnet_vm            = ["172.16.2.0/26"]

enable_bastion                = true
enable_firewall               = true
enable_firewall_as_dns_server = true
firewall_sku_tier             = "Premium" # "Standard" # "Basic" # "Standard" # "Premium" #

enable_vm_jumpbox_linux   = false
enable_vm_jumpbox_windows = true

domain_name       = "azure-aks-enterprise.com"