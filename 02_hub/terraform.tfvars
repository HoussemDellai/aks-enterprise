prefix = "lzaks-hub-weu"

tenant_id_hub       = "a8f7faa1-3e2e-4d84-a6cb-daf7eb97d6e4"
subscription_id_hub = "38977b70-47bf-4da5-a492-88712fce8725"

tenant_id_spoke       = "558506eb-9459-4ef3-b920-ad55c555e729"
subscription_id_spoke = "17b12858-3960-4e6f-a663-a06fdae23428"

resources_location = "swedencentral" # "francecentral" # "westcentralus" # 

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
enable_vm_jumpbox_windows = false

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
