# #--------------------------------------------------------------------------------
# # Local variables
# #--------------------------------------------------------------------------------

# locals {
#   resource_group_name               = "${var.prefix}-aks-rg"
#   node_resource_group               = "${var.prefix}-aks-managed-rg"
#   resources_location                = "westeurope"
#   aks_name                          = "aks-cluster"
#   kubernetes_version                = "1.23.5"
#   acr_name                          = "${var.prefix}acrforaks"
#   keyvault_name                     = "${var.prefix}kvforaks"
#   aks_admin_group_object_ids        = ["1eb16a7c-42cc-49e3-8ff0-d179433be6a6"] # HoussemDellaiGroup
#   virtual_network_address_prefix    = "10.0.0.0/8"
#   subnet_pods_address_prefix        = ["10.240.0.0/24"]
#   subnet_nodes_address_prefix       = ["10.241.0.0/16"]
#   app_gateway_subnet_address_prefix = ["10.1.0.0/16"]
#   aks_service_cidr                  = "10.0.0.0/16"
#   aks_dns_service_ip                = "10.0.0.10"
#   aks_docker_bridge_cidr            = "172.17.0.1/16"
# }