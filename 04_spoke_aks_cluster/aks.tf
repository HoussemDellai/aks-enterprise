resource "azurerm_subnet" "subnet_system_nodes" {
  name                 = "subnet-nodes"
  virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name # azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name  # azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_system_nodes
}

resource "azurerm_subnet" "subnet_system_pods" {
  name                 = "subnet-pods"
  virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name # azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name  # azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_system_pods

  # src: https://github.com/hashicorp/terraform-provider-azurerm/blob/4ea5f92ccc27a75807d704f6d66d53a6c31459cb/internal/services/containers/kubernetes_cluster_node_pool_resource_test.go#L1433
  delegation {
    name = "Microsoft.ContainerService.managedClusters"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_subnet" "subnet_apiserver" {
  count                = var.enable_apiserver_vnet_integration ? 1 : 0
  name                 = "subnet-apiserver"
  virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name
  resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_apiserver_vnetint

  delegation {
    name = "Microsoft.ContainerService.managedClusters"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks-cluster"
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = var.resources_location
  kubernetes_version                  = var.kubernetes_version
  dns_prefix                          = "aks"
  sku_tier                            = "Free" # "Paid"
  node_resource_group                 = "rg-${var.prefix}-nodes"
  private_cluster_enabled             = var.enable_private_cluster
  private_cluster_public_fqdn_enabled = false
  role_based_access_control_enabled   = true
  azure_policy_enabled                = true
  open_service_mesh_enabled           = true
  local_account_disabled              = true
  run_command_enabled                 = true
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  http_application_routing_enabled    = false
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = 24 # in the range (24 - 2160)
  private_dns_zone_id                 = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
  custom_ca_trust_certificates_base64 = null
  api_server_authorized_ip_ranges     = null
  tags                                = var.tags
  node_os_channel_upgrade             = "NodeImage"  # Unmanaged, SecurityPatch, NodeImage and None
  automatic_channel_upgrade           = "node-image" # none, patch, rapid, node-image, stable
  # public_network_access_enabled       = true # deprecated

  api_server_access_profile {
    authorized_ip_ranges     = var.enable_private_cluster ? null : ["0.0.0.0/0"] # when private cluster, this should not be enabled
    subnet_id                = var.enable_apiserver_vnet_integration ? azurerm_subnet.subnet_apiserver.0.id : null
    vnet_integration_enabled = var.enable_apiserver_vnet_integration
  }

  default_node_pool {
    name                         = "systempool"
    temporary_name_for_rotation  = "systempool"
    vm_size                      = "Standard_D2s_v5" # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "standard_d2pds_v5"
    enable_auto_scaling          = true
    node_count                   = 2
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 110
    os_disk_size_gb              = var.aks_agent_os_disk_size
    os_disk_type                 = "Managed" # "Ephemeral" # 
    ultra_ssd_enabled            = false
    os_sku                       = "Ubuntu"                                        # Ubuntu, AzureLinux, Windows2019, Windows2022
    only_critical_addons_enabled = var.enable_system_nodepool_only_critical_addons # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3]                                       # []
    vnet_subnet_id               = azurerm_subnet.subnet_system_nodes.id
    pod_subnet_id                = var.aks_network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? null : azurerm_subnet.subnet_system_pods.id
    scale_down_mode              = "Deallocate" # "Delete" # Deallocate
    workload_runtime             = "OCIContainer"
    kubelet_disk_type            = "OS" # "Temporary" # 
    enable_node_public_ip        = false
    enable_host_encryption       = false
    fips_enabled                 = false
    custom_ca_trust_enabled      = false
    message_of_the_day           = "Hello from Azure AKS cluster!"
    tags                         = var.tags
  }

  identity {
    type         = "UserAssigned" # "SystemAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity_aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.identity-kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.identity-kubelet.principal_id # there is no object_id
    user_assigned_identity_id = azurerm_user_assigned_identity.identity-kubelet.id
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = var.enable_aks_admin_group || var.enable_aks_admin_rbac
    admin_group_object_ids = var.enable_aks_admin_group ? [azuread_group.aks_admins.0.object_id] : null
    tenant_id              = var.enable_aks_admin_group ? data.azurerm_subscription.subscription_spoke.tenant_id : null
  }

  network_profile {
    # ebpf_data_plane     = "cilium"
    # network_plugin_mode = var.network_plugin_mode # When ebpf_data_plane is set to cilium, one of either network_plugin_mode = "overlay" or pod_subnet_id must be specified.
    # network_plugin_mode = var.network_plugin_mode # use it when using CNI
    # network_mode        = "bridge"               # " transparent"
    network_plugin    = var.aks_network_plugin # "kubenet", "azure", "none"
    network_policy    = "calico"               # "azure" 
    dns_service_ip    = var.aks_dns_service_ip
    service_cidr      = var.cidr_aks_service
    outbound_type     = var.aks_outbound_type # "userAssignedNATGateway" "loadBalancer" "userDefinedRouting" "managedNATGateway"
    load_balancer_sku = "standard"            # "basic"
    # pod_cidr          = null                  # can only be set when network_plugin is set to kubenet
    # pod_cidr    = var.aks_network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? "10.10.240.0/20" : null # only set when network_plugin is set to kubenet
    ip_versions = ["IPv4"] # ["IPv4", "IPv6"]

    dynamic "load_balancer_profile" {
      for_each = var.aks_outbound_type == "loadBalancer" ? ["any_value"] : []
      content {
        idle_timeout_in_minutes   = 30
        managed_outbound_ip_count = 2
      }
    }

    dynamic "nat_gateway_profile" {
      for_each = var.aks_outbound_type == "userAssignedNATGateway" ? ["any_value"] : []
      # count = var.enable_monitoring ? 1 : 0 # count couldn't be used inside nested block
      content {
        idle_timeout_in_minutes   = 4 # Must be between 4 and 120 inclusive. Defaults to 4
        managed_outbound_ip_count = 2 # Must be between 1 and 100 inclusive
      }
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = false
    expander                         = "random" # least-waste, priority, most-pods
    max_graceful_termination_sec     = "600"
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
    empty_bulk_delete_max            = "10"
    skip_nodes_with_local_storage    = true
    skip_nodes_with_system_pods      = true
  }

  dynamic "ingress_application_gateway" {
    for_each = var.enable_app_gateway ? ["any_value"] : []
    # count = var.enable_app_gateway ? 1 : 0 # count couldn't be used inside nested block
    content {
      gateway_id = data.terraform_remote_state.spoke_aks.outputs.application_gateway.id # azurerm_application_gateway.appgw.0.id
      # other options if we want to allow the AGIC addon to create a new AppGW 
      # and not use an existing one
      # subnet_id    = # link AppGW to specific Subnet
      # gateway_name = # give a name to the generated AppGW
      # subnet_cidr  = # specify the CIDR range for the Subnet that will be created
    }
  }
  # ingress_application_gateway {
  #   gateway_id = var.enable_app_gateway ? azurerm_application_gateway.appgw.0.id : null # doesn't work when resource disabled
  # }

  dynamic "oms_agent" {
    for_each = var.enable_monitoring ? ["any_value"] : []
    # count = var.enable_monitoring ? 1 : 0 # count couldn't be used inside nested block
    content {
      log_analytics_workspace_id      = data.terraform_remote_state.management.0.outputs.log_analytics_workspace.id # azurerm_log_analytics_workspace.workspace.id
      msi_auth_for_monitoring_enabled = true
    }
  }

  # microsoft_defender {
  #   log_analytics_workspace_id = ""
  # }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  dynamic "maintenance_window" {
    for_each = var.enable_maintenance_window ? ["any_value"] : []
    content {
      allowed {
        day   = "Saturday"
        hours = [2, 8]
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.enable_maintenance_window ? ["any_value"] : []
    content {
      frequency    = "Weekly" # AbsoluteMonthly, RelativeMonthly
      interval     = 1
      duration     = 9
      day_of_week  = "Monday" # Tuesday, Wednesday, Thurday, Friday, Saturday and Sunday
      day_of_month = null
      start_time   = "02:00"
      utc_offset   = "+01:00"
      start_date   = "2023-08-26T00:00:00Z"
      not_allowed {
        end   = "2023-11-30T00:00:00Z"
        start = "2023-11-26T00:00:00Z"
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.enable_maintenance_window ? ["any_value"] : []
    content {
      frequency    = "Weekly" # AbsoluteMonthly, RelativeMonthly
      interval     = 1
      duration     = 9
      day_of_week  = "Monday" # Tuesday, Wednesday, Thurday, Friday, Saturday and Sunday
      day_of_month = null
      start_time   = "02:00"
      utc_offset   = "+01:00"
      start_date   = "2023-08-26T00:00:00Z"
      not_allowed {
        end   = "2023-11-30T00:00:00Z"
        start = "2023-11-26T00:00:00Z"
      }
    }
  }

  workload_autoscaler_profile {
    keda_enabled                    = false # true
    vertical_pod_autoscaler_enabled = true
  }

  # linux_profile {
  #   admin_username = var.vm_user_name
  #   ssh_key {
  #     key_data = file(var.public_ssh_key_path)
  #   }
  # }

  monitor_metrics {
    #   annotations_allowed = []
    #   labels_allowed = []
  }

  storage_profile {
    file_driver_enabled         = true
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    snapshot_controller_enabled = true
    # disk_driver_version         = "v2" # not yet available
  }

  # service_mesh_profile {
  #   mode = "Istio"
  # }

  # web_app_routing {
  #   dns_zone_id = null #TODO
  # }

  depends_on = [
    azurerm_subnet_route_table_association.association_rt_subnet_system_nodes,
    azurerm_subnet_route_table_association.association_rt_subnet_system_pods,
    azurerm_subnet_route_table_association.association_rt_subnet_user_nodes[0],
    azurerm_subnet_route_table_association.association_rt_subnet_user_pods[0]
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
      microsoft_defender,
      # oms_agent
      network_profile.0.nat_gateway_profile
    ]
    # precondition {
    #   condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type != "")
    #   error_message = "Either `client_id` and `client_secret` or `identity_type` must be set."
    # }
    # precondition {
    #   # Why don't use var.identity_ids != null && length(var.identity_ids)>0 ? Because bool expression in Terraform is not short circuit so even var.identity_ids is null Terraform will still invoke length function with null and cause error. https://github.com/hashicorp/terraform/issues/24128
    #   condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type == "SystemAssigned") || (var.identity_ids == null ? false : length(var.identity_ids) > 0)
    #   error_message = "If use identity and `UserAssigned` or `SystemAssigned, UserAssigned` is set, an `identity_ids` must be set as well."
    # }
    # precondition {
    #   condition     = !(var.microsoft_defender_enabled && !var.log_analytics_workspace_enabled)
    #   error_message = "Enabling Microsoft Defender requires that `log_analytics_workspace_enabled` be set to true."
    # }
  }
}

# resource "azurerm_kubernetes_cluster" "aks" {
#   name                                = "aks-cluster"
#   resource_group_name                 = azurerm_resource_group.rg.name
#   location                            = var.resources_location
#   kubernetes_version                  = var.kubernetes_version
#   sku_tier                            = "Free" # "Paid"
#   dns_prefix                          = "aks"
#   node_resource_group                 = "rg-${var.prefix}-nodes"
#   private_cluster_enabled             = var.enable_private_cluster
#   private_cluster_public_fqdn_enabled = false
#   public_network_access_enabled       = true
#   role_based_access_control_enabled   = true
#   azure_policy_enabled                = true
#   open_service_mesh_enabled           = true
#   local_account_disabled              = true
#   run_command_enabled                 = true
#   oidc_issuer_enabled                 = true
#   workload_identity_enabled           = true
#   http_application_routing_enabled    = false
#   image_cleaner_enabled               = true
#   image_cleaner_interval_hours        = 24 # in the range (24 - 2160)
#   private_dns_zone_id                 = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
#   custom_ca_trust_certificates_base64 = null
#   api_server_authorized_ip_ranges     = null
#   tags                                = var.tags
#   node_os_channel_upgrade             = "NodeImage"  # Unmanaged, SecurityPatch, NodeImage and None
#   automatic_channel_upgrade           = "node-image" # none, patch, rapid, node-image, stable

#   api_server_access_profile {
#     authorized_ip_ranges     = var.enable_private_cluster ? null : ["0.0.0.0/0"] # when private cluster, this should not be enabled
#     subnet_id                = azurerm_subnet.subnet_apiserver.0.id
#     vnet_integration_enabled = var.enable_apiserver_vnet_integration
#   }

#   default_node_pool {
#     name                         = "systempool"
#     temporary_name_for_rotation  = "systempool"
#     node_count                   = 1
#     enable_auto_scaling          = true
#     min_count                    = 1
#     max_count                    = 3
#     max_pods                     = 110
#     vm_size                      = "Standard_D2s_v5" # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "standard_d2pds_v5"
#     os_disk_size_gb              = var.aks_agent_os_disk_size
#     os_disk_type                 = "Managed" # "Ephemeral" # 
#     ultra_ssd_enabled            = false
#     os_sku                       = "Ubuntu"                                        # Ubuntu, AzureLinux, Windows2019, Windows2022
#     only_critical_addons_enabled = var.enable_system_nodepool_only_critical_addons # taint default node pool with CriticalAddonsOnly=true:NoSchedule
#     zones                        = [1, 2, 3]                                       # []
#     vnet_subnet_id               = azurerm_subnet.subnet_system_nodes.id
#     pod_subnet_id                = var.aks_network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? null : azurerm_subnet.subnet_system_pods.id
#     scale_down_mode              = "Deallocate" # "Delete" # Deallocate
#     workload_runtime             = "OCIContainer"
#     kubelet_disk_type            = "OS" # "Temporary" # 
#     enable_node_public_ip        = false
#     enable_host_encryption       = false
#     fips_enabled                 = false
#     custom_ca_trust_enabled      = false
#     message_of_the_day           = "Hello from Azure AKS cluster!"
#     tags                         = var.tags
#   }

#   identity {
#     type         = "UserAssigned" # "SystemAssigned"
#     identity_ids = [azurerm_user_assigned_identity.identity_aks.id]
#   }

#   kubelet_identity {
#     client_id                 = azurerm_user_assigned_identity.identity-kubelet.client_id
#     object_id                 = azurerm_user_assigned_identity.identity-kubelet.principal_id # there is no object_id
#     user_assigned_identity_id = azurerm_user_assigned_identity.identity-kubelet.id
#   }

#   azure_active_directory_role_based_access_control {
#     managed                = true
#     azure_rbac_enabled     = var.enable_aks_admin_group || var.enable_aks_admin_rbac
#     admin_group_object_ids = var.enable_aks_admin_group ? [azuread_group.aks_admins.0.object_id] : null
#     tenant_id              = var.enable_aks_admin_group ? data.azurerm_subscription.subscription_spoke.tenant_id : null
#   }

#   network_profile {
#     # ebpf_data_plane     = "cilium"
#     # network_plugin_mode = var.network_plugin_mode # When ebpf_data_plane is set to cilium, one of either network_plugin_mode = "overlay" or pod_subnet_id must be specified.
#     # network_plugin_mode = var.network_plugin_mode # use it when using CNI
#     # network_mode        = "bridge"               # " transparent"
#     network_plugin    = var.aks_network_plugin # "kubenet", "azure", "none"
#     network_policy    = "calico"               # "azure" 
#     dns_service_ip    = var.aks_dns_service_ip
#     service_cidr      = var.cidr_aks_service
#     outbound_type     = var.aks_outbound_type # "userAssignedNATGateway" "loadBalancer" "userDefinedRouting" "managedNATGateway"
#     load_balancer_sku = "standard"            # "basic"
#     # pod_cidr          = null                  # can only be set when network_plugin is set to kubenet
#     # pod_cidr    = var.aks_network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? "10.10.240.0/20" : null # only set when network_plugin is set to kubenet
#     ip_versions = ["IPv4"] # ["IPv4", "IPv6"]

#     dynamic "load_balancer_profile" {
#       for_each = var.aks_outbound_type == "loadBalancer" ? ["any_value"] : []
#       content {
#         idle_timeout_in_minutes   = 30
#         managed_outbound_ip_count = 2
#       }
#     }

#     dynamic "nat_gateway_profile" {
#       for_each = var.aks_outbound_type == "userAssignedNATGateway" ? ["any_value"] : []
#       # count = var.enable_monitoring ? 1 : 0 # count couldn't be used inside nested block
#       content {
#         idle_timeout_in_minutes   = 4 # Must be between 4 and 120 inclusive. Defaults to 4
#         managed_outbound_ip_count = 2 # Must be between 1 and 100 inclusive
#       }
#     }
#   }

#   auto_scaler_profile {
#     balance_similar_node_groups      = false
#     expander                         = "random" # least-waste, priority, most-pods
#     max_graceful_termination_sec     = "600"
#     max_node_provisioning_time       = "15m"
#     max_unready_nodes                = 3
#     max_unready_percentage           = 45
#     new_pod_scale_up_delay           = "10s"
#     scale_down_delay_after_add       = "10m"
#     scale_down_delay_after_delete    = "10s"
#     scale_down_delay_after_failure   = "3m"
#     scan_interval                    = "10s"
#     scale_down_unneeded              = "10m"
#     scale_down_unready               = "20m"
#     scale_down_utilization_threshold = "0.5"
#     empty_bulk_delete_max            = "10"
#     skip_nodes_with_local_storage    = true
#     skip_nodes_with_system_pods      = true
#   }

#   dynamic "ingress_application_gateway" {
#     for_each = var.enable_app_gateway ? ["any_value"] : []
#     # count = var.enable_app_gateway ? 1 : 0 # count couldn't be used inside nested block
#     content {
#       gateway_id = data.terraform_remote_state.spoke_aks.outputs.application_gateway.id # azurerm_application_gateway.appgw.0.id
#       # other options if we want to allow the AGIC addon to create a new AppGW 
#       # and not use an existing one
#       # subnet_id    = # link AppGW to specific Subnet
#       # gateway_name = # give a name to the generated AppGW
#       # subnet_cidr  = # specify the CIDR range for the Subnet that will be created
#     }
#   }
#   # ingress_application_gateway {
#   #   gateway_id = var.enable_app_gateway ? azurerm_application_gateway.appgw.0.id : null # doesn't work when resource disabled
#   # }

#   dynamic "oms_agent" {
#     for_each = var.enable_monitoring ? ["any_value"] : []
#     # count = var.enable_monitoring ? 1 : 0 # count couldn't be used inside nested block
#     content {
#       log_analytics_workspace_id      = data.terraform_remote_state.management.0.outputs.log_analytics_workspace.id # azurerm_log_analytics_workspace.workspace.id
#       msi_auth_for_monitoring_enabled = true
#     }
#   }

#   # microsoft_defender {
#   #   log_analytics_workspace_id = ""
#   # }

#   key_vault_secrets_provider {
#     secret_rotation_enabled  = true
#     secret_rotation_interval = "2m"
#   }

#   dynamic "maintenance_window" {
#     for_each = var.enable_maintenance_window ? ["any_value"] : []
#     content {
#       allowed {
#         day   = "Saturday"
#         hours = [2, 8]
#       }
#     }
#   }

#   dynamic "maintenance_window_auto_upgrade" {
#     for_each = var.enable_maintenance_window ? ["any_value"] : []
#     content {
#       frequency    = "Weekly" # AbsoluteMonthly, RelativeMonthly
#       interval     = 1
#       duration     = 9
#       day_of_week  = "Monday" # Tuesday, Wednesday, Thurday, Friday, Saturday and Sunday
#       day_of_month = null
#       start_time   = "02:00"
#       utc_offset   = "+01:00"
#       start_date   = "2023-08-26T00:00:00Z"
#       not_allowed {
#         end   = "2023-11-30T00:00:00Z"
#         start = "2023-11-26T00:00:00Z"
#       }
#     }
#   }

#   dynamic "maintenance_window_node_os" {
#     for_each = var.enable_maintenance_window ? ["any_value"] : []
#     content {
#       frequency    = "Weekly" # AbsoluteMonthly, RelativeMonthly
#       interval     = 1
#       duration     = 9
#       day_of_week  = "Monday" # Tuesday, Wednesday, Thurday, Friday, Saturday and Sunday
#       day_of_month = null
#       start_time   = "02:00"
#       utc_offset   = "+01:00"
#       start_date   = "2023-08-26T00:00:00Z"
#       not_allowed {
#         end   = "2023-11-30T00:00:00Z"
#         start = "2023-11-26T00:00:00Z"
#       }
#     }
#   }

#   workload_autoscaler_profile {
#     keda_enabled                    = false # true
#     vertical_pod_autoscaler_enabled = true
#   }

#   # linux_profile {
#   #   admin_username = var.vm_user_name
#   #   ssh_key {
#   #     key_data = file(var.public_ssh_key_path)
#   #   }
#   # }

#   monitor_metrics {
#     #   annotations_allowed = []
#     #   labels_allowed = []
#   }

#   storage_profile { #todo
#     file_driver_enabled = true
#     blob_driver_enabled = true
#     disk_driver_enabled = true
#     # disk_driver_version         = "v2"
#     snapshot_controller_enabled = true
#   }

#   # service_mesh_profile {
#   #   mode = "Istio"
#   # }

#   # web_app_routing {
#   #   dns_zone_id = null #TODO
#   # }

#   depends_on = [
#     azurerm_subnet_route_table_association.association_route_table_subnet_system_nodes,
#     azurerm_subnet_route_table_association.association_route_table_subnet_system_pods,
#     azurerm_subnet_route_table_association.association_route_table_subnet_system_nodes[0],
#     azurerm_subnet_route_table_association.association_route_table_subnet_system_pods[0]
#     # azurerm_virtual_network.vnet_spoke_aks,
#     # azurerm_application_gateway.appgw
#   ]
  # lifecycle {
  #   ignore_changes = [kubernetes_version]

  #   precondition {
  #     condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type != "")
  #     error_message = "Either `client_id` and `client_secret` or `identity_type` must be set."
  #   }
  #   precondition {
  #     # Why don't use var.identity_ids != null && length(var.identity_ids)>0 ? Because bool expression in Terraform is not short circuit so even var.identity_ids is null Terraform will still invoke length function with null and cause error. https://github.com/hashicorp/terraform/issues/24128
  #     condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type == "SystemAssigned") || (var.identity_ids == null ? false : length(var.identity_ids) > 0)
  #     error_message = "If use identity and `UserAssigned` is set, an `identity_ids` must be set as well."
  #   }
  #   precondition {
  #     condition     = !(var.microsoft_defender_enabled && !var.log_analytics_workspace_enabled)
  #     error_message = "Enabling Microsoft Defender requires that `log_analytics_workspace_enabled` be set to true."
  #   }
  #   precondition {
  #     condition     = !(var.load_balancer_profile_enabled && var.load_balancer_sku != "standard")
  #     error_message = "Enabling load_balancer_profile requires that `load_balancer_sku` be set to `standard`"
  #   }
  #   precondition {
  #     condition     = local.automatic_channel_upgrade_check
  #     error_message = "Either disable automatic upgrades, or specify `kubernetes_version` or `orchestrator_version` only up to the minor version when using `automatic_channel_upgrade=patch`. You don't need to specify `kubernetes_version` at all when using `automatic_channel_upgrade=stable|rapid|node-image`, where `orchestrator_version` always must be set to `null`."
  #   }
  #   precondition {
  #     condition     = var.role_based_access_control_enabled || !var.rbac_aad
  #     error_message = "Enabling Azure Active Directory integration requires that `role_based_access_control_enabled` be set to true."
  #   }
  #   precondition {
  #     condition     = !(var.kms_enabled && var.identity_type != "UserAssigned")
  #     error_message = "KMS etcd encryption doesn't work with system-assigned managed identity."
  #   }
  #   precondition {
  #     condition     = !var.workload_identity_enabled || var.oidc_issuer_enabled
  #     error_message = "`oidc_issuer_enabled` must be set to `true` to enable Azure AD Workload Identity"
  #   }
  #   precondition {
  #     condition     = var.network_plugin_mode != "overlay" || var.network_plugin == "azure"
  #     error_message = "When network_plugin_mode is set to `overlay`, the network_plugin field can only be set to azure."
  #   }
  #   precondition {
  #     condition     = var.ebpf_data_plane != "cilium" || var.network_plugin == "azure"
  #     error_message = "When ebpf_data_plane is set to cilium, the network_plugin field can only be set to azure."
  #   }
  #   precondition {
  #     condition     = var.ebpf_data_plane != "cilium" || var.network_plugin_mode == "overlay" || var.pod_subnet_id != null
  #     error_message = "When ebpf_data_plane is set to cilium, one of either network_plugin_mode = `overlay` or pod_subnet_id must be specified."
  #   }
  #   precondition {
  #     condition     = can(coalesce(var.cluster_name, var.prefix))
  #     error_message = "You must set one of `var.cluster_name` and `var.prefix` to create `azurerm_kubernetes_cluster.main`."
  #   }
  #   precondition {
  #     condition     = var.automatic_channel_upgrade != "node-image" || var.node_os_channel_upgrade == "NodeImage"
  #     error_message = "`node_os_channel_upgrade` must be set to `NodeImage` if `automatic_channel_upgrade` has been set to `node-image`."
  #   }
#   lifecycle {
#     # prevent_destroy       = true
#     # create_before_destroy = true
#     ignore_changes = [
#       # all, # ignore all attributes
#       monitor_metrics,
#       default_node_pool[0].node_count,
#       microsoft_defender,
#       # oms_agent
#       network_profile.0.nat_gateway_profile
#     ]
#     # precondition {
#     #   condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type != "")
#     #   error_message = "Either `client_id` and `client_secret` or `identity_type` must be set."
#     # }
#     # precondition {
#     #   # Why don't use var.identity_ids != null && length(var.identity_ids)>0 ? Because bool expression in Terraform is not short circuit so even var.identity_ids is null Terraform will still invoke length function with null and cause error. https://github.com/hashicorp/terraform/issues/24128
#     #   condition     = (var.client_id != "" && var.client_secret != "") || (var.identity_type == "SystemAssigned") || (var.identity_ids == null ? false : length(var.identity_ids) > 0)
#     #   error_message = "If use identity and `UserAssigned` or `SystemAssigned, UserAssigned` is set, an `identity_ids` must be set as well."
#     # }
#     # precondition {
#     #   condition     = !(var.microsoft_defender_enabled && !var.log_analytics_workspace_enabled)
#     #   error_message = "Enabling Microsoft Defender requires that `log_analytics_workspace_enabled` be set to true."
#     # }
#   }
# }

resource "azurerm_user_assigned_identity" "identity-kubelet" {
  # count               = var.enable_aks_cluster ? 1 : 0
  name                = "identity-kubelet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "role_acrpull" {
  # count                            = var.enable_aks_cluster ? 1 : 0
  scope                            = data.terraform_remote_state.spoke_aks.outputs.acr.id # azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.identity-kubelet.principal_id
  skip_service_principal_aad_check = true
}

data "azurerm_kubernetes_service_versions" "aks" {
  location = var.resources_location
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.aks.latest_version
}
