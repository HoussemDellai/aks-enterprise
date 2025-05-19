resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks-cluster"
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = azurerm_resource_group.rg.location
  kubernetes_version                  = "1.33.0"
  dns_prefix                          = "aks"
  sku_tier                            = "Free" # "Paid"
  private_cluster_enabled             = false
  private_cluster_public_fqdn_enabled = false
  role_based_access_control_enabled   = false
  azure_policy_enabled                = false
  open_service_mesh_enabled           = false
  local_account_disabled              = false
  run_command_enabled                 = false
  oidc_issuer_enabled                 = false
  workload_identity_enabled           = false
  http_application_routing_enabled    = false
  image_cleaner_enabled               = false
  cost_analysis_enabled               = false
  image_cleaner_interval_hours        = 24           # in the range (24 - 2160)
  private_dns_zone_id                 = null         # azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
  node_os_upgrade_channel             = "NodeImage"  # Unmanaged, SecurityPatch, NodeImage and None. Defaults to NodeImage
  automatic_upgrade_channel           = "node-image" # patch, rapid, node-image and stable. Omitting this field sets this value to none

  network_profile {
    network_plugin      = "azure" # var.aks_network_plugin # "kubenet", "azure", "none"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"             # azure and cilium
    network_policy      = "cilium"             # calico, azure and cilium
    outbound_type       = "userDefinedRouting" # "managedNATGateway" "userAssignedNATGateway" "loadBalancer" 
    load_balancer_sku   = "standard"           # "basic"
    ip_versions         = ["IPv4"]             # ["IPv4", "IPv6"]
    pod_cidr            = "10.10.240.0/20"
    pod_cidrs           = ["10.10.240.0/20"]
    service_cidr        = "10.128.0.0/22"
    service_cidrs       = ["10.128.0.0/22"]
    dns_service_ip      = "10.128.0.10"
  }

  default_node_pool {
    name                         = "systempool"
    temporary_name_for_rotation  = "syspooltmp"
    vm_size                      = "Standard_D2s_v5" # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "standard_d2pds_v5"
    auto_scaling_enabled         = true
    node_count                   = 2
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 110
    os_disk_size_gb              = 40
    os_disk_type                 = "Managed" # "Ephemeral" # 
    ultra_ssd_enabled            = false
    os_sku                       = "Ubuntu"  # Ubuntu, AzureLinux, Windows2019, Windows2022
    only_critical_addons_enabled = false     # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3] # []
    vnet_subnet_id               = azurerm_subnet.snet_aks.id
    pod_subnet_id                = null         # azurerm_subnet.subnet_system_pods.id
    scale_down_mode              = "Deallocate" # "Delete" # Deallocate
    workload_runtime             = "OCIContainer"
    kubelet_disk_type            = "OS" # "Temporary" # 
    node_public_ip_enabled       = false
    host_encryption_enabled      = false
    fips_enabled                 = false
  }

  identity {
    type = "SystemAssigned"
  }

  # kubelet_identity {

  # }

  depends_on = [
    azurerm_subnet_route_table_association.association_rt_subnet_aks
    # azurerm_virtual_network.vnet_spoke_aks,
    # azurerm_application_gateway.appgw
  ]

  lifecycle {
    # prevent_destroy       = true
    # create_before_destroy = true
    ignore_changes = [
      # all, # ignore all attributes
      monitor_metrics,
      default_node_pool[0].node_count,
      microsoft_defender
    ]
  }
}
