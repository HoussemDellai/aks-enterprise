module "level01_management" {
  source = "./01_management"

  tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
  subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

  tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
  subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

  resources_location      = "westeurope" # "francecentral" # "westcentralus" # 
  log_analytics_workspace = "loganalyticsforaks011"

#   providers = {
#     azurerm.subscription_hub = azurerm.subscription_hub
#   }
}

# provider "azurerm" {
#   alias           = "subscription_hub"
#   subscription_id = var.subscription_id_hub
#   tenant_id       = var.tenant_id_hub
#   # client_id       = "a0d7fbe0-dca2-4848-b6ac-ad15e2c31840"
#   # client_secret   = "BAFHTR3235FEHsdfb%#$W%weF#@a"
#   # auxiliary_tenant_ids = ["558506eb-9459-4ef3-b920-ad55c555e729"]
#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#     key_vault {
#       purge_soft_delete_on_destroy          = true
#       recover_soft_deleted_key_vaults       = true
#       purge_soft_deleted_secrets_on_destroy = true
#       recover_soft_deleted_secrets          = true
#     }
#     log_analytics_workspace {
#       permanently_delete_on_destroy = true
#     }
#     virtual_machine {
#       delete_os_disk_on_deletion     = true
#       graceful_shutdown              = false
#       skip_shutdown_and_force_delete = false
#     }
#   }
# }

module "level02_hub" {
  source = "./02_hub"

  tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
  subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

  tenant_id_spoke       = "558506eb-9459-4ef3-b920-ad55c555e729"
  subscription_id_spoke = "17b12858-3960-4e6f-a663-a06fdae23428"

  resources_location = "westeurope" # "francecentral" # "westcentralus" # 

  cidr_vnet_hub        = ["172.16.0.0/16"]
  cidr_subnet_firewall = ["172.16.0.0/26"]
  cidr_subnet_bastion  = ["172.16.1.0/27"]

  enable_bastion  = false
  enable_firewall = true

  depends_on = [
    module.level01_management
  ]
}

# module "level03_spoke_aks_infra" {
#   source = "./03_spoke_aks_infra"

#   tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
#   subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

#   tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
#   subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

#   resources_location   = "westeurope" # "francecentral" # "westcentralus" # 
#   acr_name             = "acrforakstf01357"
#   keyvault_name        = "kvforaks01357"
#   storage_account_name = "storageforaks01357"

#   cidr_vnet_spoke_aks      = ["10.1.0.0/16"]
#   cidr_subnet_appgateway   = ["10.1.1.0/24"]
#   cidr_subnet_spoke_aks_pe = ["10.1.2.0/28"]

#   enable_grafana_prometheus = true
#   enable_app_gateway        = true
#   enable_keyvault           = true
#   enable_storage_account    = true
#   enable_private_keyvault   = true
#   enable_private_acr        = true

#   enable_monitoring = true

#   # integration with Hub & Firewall
#   enable_hub_spoke    = true
#   enable_firewall     = true
#   enable_vnet_peering = true

#   depends_on = [
#     module.level02_hub
#   ]
# }

# module "level04_spoke_aks_cluster" {
#   source = "./04_spoke_aks_cluster"

#   tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
#   subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

#   tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
#   subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

#   resources_location = "westeurope" # "francecentral" # "westcentralus" # "northeurope" # 

#   kubernetes_version   = "1.26.3" # "1.26.0"
#   aad_group_aks_admins = "aad_group_aks_admins"

#   cidr_subnet_nodes             = ["10.1.3.0/24"]
#   cidr_subnet_apiserver_vnetint = ["10.1.4.0/28"]
#   cidr_subnet_pods              = ["10.1.240.0/20"]

#   cidr_aks_service   = "10.0.0.0/16"
#   aks_dns_service_ip = "10.0.0.10"
#   aks_outbound_type  = "userDefinedRouting" # "userAssignedNATGateway" # "loadBalancer" , userDefinedRouting, managedNATGateway
#   enable_app_gateway = true

#   enable_private_cluster                      = false
#   enable_apiserver_vnet_integration           = true
#   enable_nodepool_apps                        = true
#   enable_nodepool_spot                        = false
#   enable_system_nodepool_only_critical_addons = false
#   enable_aks_admin_group                      = false
#   enable_aks_admin_rbac                       = true

#   enable_grafana_prometheus = true
#   enable_monitoring         = true

#   # integration with Hub network
#   enable_hub_spoke    = true
#   enable_firewall     = true
#   enable_vnet_peering = true
#   depends_on = [
#     module.level03_spoke_aks_infra
#   ]
# }

# module "level05_monitoring" {
#   source = "./05_monitoring"

#   tenant_id_hub       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
#   subscription_id_hub = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"

#   tenant_id_spoke       = "16b3c013-d300-468d-ac64-7eda0820b6d3" # "558506eb-9459-4ef3-b920-ad55c555e729"
#   subscription_id_spoke = "82f6d75e-85f4-434a-ab74-5dddd9fa8910" # "17b12858-3960-4e6f-a663-a06fdae23428"

#   resources_location   = "westeurope" # "francecentral" # "westcentralus" # 
#   enable_nsg_flow_logs = true

#   depends_on = [
#     module.level04_spoke_aks_cluster
#   ]
# }
