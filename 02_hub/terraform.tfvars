prefix = "lzaks"
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
firewall_sku_tier             = "Standard" # "Basic" # "Standard" # "Premium" #

enable_vm_jumpbox_linux   = false
enable_vm_jumpbox_windows = true

domain_name       = "houssem17.com"
AgreedBy_IP_v6    = "2a04:cec0:11d9:24c8:8898:3820:8631:d83"
AgreedAt_DateTime = "2023-08-13T15:06:59.264Z"

contact = {
  nameFirst = "azureuser"
  nameLast  = "Dellai"
  email     = "houssem.dellai@live.com" # you'll get verification email
  phone     = "+33.762954328"
  addressMailing = {
    address1   = "1 Microsoft Way"
    city       = "Redmond"
    state      = "WA"
    country    = "US"
    postalCode = "98052"
  }
}
