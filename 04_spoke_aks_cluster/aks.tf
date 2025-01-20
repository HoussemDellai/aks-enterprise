resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks-cluster-swc"
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = var.location
  kubernetes_version                  = var.kubernetes_version
  dns_prefix                          = "aks"
  sku_tier                            = "Free" # "Paid"
  node_resource_group                 = "rg-${var.prefix}-spoke-aks-nodes"
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
  cost_analysis_enabled               = false
  image_cleaner_interval_hours        = 24 # in the range (24 - 2160)
  private_dns_zone_id                 = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
  tags                                = var.tags
  node_os_upgrade_channel             = "NodeImage"  # Unmanaged, SecurityPatch, NodeImage and None. Defaults to NodeImage
  automatic_upgrade_channel           = "node-image" # patch, rapid, node-image and stable. Omitting this field sets this value to none

  network_profile {
    network_plugin      = "azure" # var.aks_network_plugin # "kubenet", "azure", "none"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium" # azure and cilium
    network_policy      = "cilium" # calico, azure and cilium
    dns_service_ip      = var.aks_dns_service_ip
    service_cidr        = var.cidr_aks_service
    service_cidrs       = [var.cidr_aks_service]
    outbound_type       = var.aks_outbound_type # "userAssignedNATGateway" "loadBalancer" "userDefinedRouting" "managedNATGateway"
    load_balancer_sku   = "standard"            # "basic"
    ip_versions         = ["IPv4"]              # ["IPv4", "IPv6"]
    pod_cidrs           = ["10.10.240.0/20"]
    pod_cidr            = "10.10.240.0/20"
    # pod_cidr    = var.aks_network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? "10.10.240.0/20" : null # only set when network_plugin is set to kubenet

    dynamic "load_balancer_profile" {
      for_each = var.aks_outbound_type == "loadBalancer" ? ["any_value"] : []
      content {
        idle_timeout_in_minutes   = 30
        managed_outbound_ip_count = 2
        outbound_ip_address_ids   = []
        outbound_ports_allocated  = 0                     # Must be between 0 and 64000 inclusive. Defaults to 0
        backend_pool_type         = "NodeIPConfiguration" # NodeIP and NodeIPConfiguration. Defaults to NodeIPConfiguration
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

  default_node_pool {
    name                         = "systempool"
    temporary_name_for_rotation  = "syspooltmp"
    vm_size                      = "Standard_D2s_v5" # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "standard_d2pds_v5"
    auto_scaling_enabled         = true
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
    vnet_subnet_id               = data.terraform_remote_state.spoke_aks.outputs.snet_aks.id
    pod_subnet_id                = null         # azurerm_subnet.subnet_system_pods.id
    scale_down_mode              = "Deallocate" # "Delete" # Deallocate
    workload_runtime             = "OCIContainer"
    kubelet_disk_type            = "OS" # "Temporary" # 
    node_public_ip_enabled       = false
    host_encryption_enabled      = false
    fips_enabled                 = false
    tags                         = var.tags

    node_network_profile {
      # allowed_host_ports {
      #   port_start = 80
      #   port_end   = 80
      #   protocol   = "TCP"
      # }
      application_security_group_ids = []
      node_public_ip_tags            = null # {}
    }

    upgrade_settings {
      max_surge                     = 1
      drain_timeout_in_minutes      = 10
      node_soak_duration_in_minutes = 0
    }
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

  api_server_access_profile {
    authorized_ip_ranges = var.enable_private_cluster ? null : ["0.0.0.0/0"] # when private cluster, this should not be enabled
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.enable_aks_admin_group || var.enable_aks_admin_rbac
    admin_group_object_ids = var.enable_aks_admin_group ? [azuread_group.aks_admins.0.object_id] : null
    tenant_id              = var.enable_aks_admin_group ? data.azurerm_subscription.subscription_spoke.tenant_id : null
  }

  web_app_routing {
    dns_zone_ids = []
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
    content {
      gateway_id = data.terraform_remote_state.spoke_aks.outputs.application_gateway.id # azurerm_application_gateway.appgw.0.id
      # other options if we want to allow the AGIC addon to create a new AppGW 
      # and not use an existing one
      # subnet_id    = # link AppGW to specific Subnet
      # gateway_name = # give a name to the generated AppGW
      # subnet_cidr  = # specify the CIDR range for the Subnet that will be created
    }
  }

  dynamic "oms_agent" {
    for_each = var.enable_monitoring ? ["any_value"] : []
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

  confidential_computing {
    sgx_quote_helper_enabled = false
  }

  # service_mesh_profile {
  #   mode = "Istio"
  # }

  # web_app_routing {
  #   dns_zone_id = null #TODO
  # }

  depends_on = [
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
  }
}
