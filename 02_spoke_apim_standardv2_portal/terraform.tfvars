prefix   = "lzapim"
location = "westeurope" # "swedencentral" # "francecentral" # "westcentralus" # 

tenant_id_hub       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_hub = "dcef7009-6b94-4382-afdc-17eb160d709a"

tenant_id_spoke       = "93139d1e-a3c1-4d78-9ed5-878be090eba4"
subscription_id_spoke = "dcef7009-6b94-4382-afdc-17eb160d709a"

# integration with Hub & Firewall
enable_hub_spoke                 = true
enable_route_traffic_to_firewall = true
enable_firewall_as_dns_server    = true
# enable_vnet_peering           = true
