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
#   cidr_subnet_pods        = ["10.240.0.0/24"]
#   cidr_subnet_nodes       = ["10.241.0.0/16"]
#   cidr_subnet_appgateway = ["10.1.0.0/16"]
#   cidr_aks_service                  = "10.0.0.0/16"
#   aks_dns_service_ip                = "10.0.0.10"
#   cidr_aks_docker_bridge            = "172.17.0.1/16"
# }