resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks-cluster"
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  dns_prefix                          = "aks"
  kubernetes_version                  = var.kubernetes_version
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  role_based_access_control_enabled   = true
  azure_policy_enabled                = true
  open_service_mesh_enabled           = false
  local_account_disabled              = true
  run_command_enabled                 = false
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  http_application_routing_enabled    = false
  image_cleaner_enabled               = true
  cost_analysis_enabled               = false
  image_cleaner_interval_hours        = 24 # in the range (24 - 2160)
  private_dns_zone_id                 = var.private_dns_zone_aks_id
  tags                                = var.tags
  node_os_upgrade_channel             = "NodeImage"  # Unmanaged, SecurityPatch, NodeImage and None. Defaults to NodeImage
  automatic_upgrade_channel           = "node-image" # patch, rapid, node-image and stable. Omitting this field sets this value to none
  node_resource_group                 = "${var.resource_group_name}-nodes"

  network_profile {
    network_plugin      = "azure" # var.aks_network_plugin # "kubenet", "azure", "none"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium" # azure and cilium
    network_policy      = "cilium"
    outbound_type       = "userDefinedRouting"
    load_balancer_sku   = "standard" # "basic"
    ip_versions         = ["IPv4"]
    dns_service_ip      = "10.0.0.10"
    service_cidr        = "10.0.0.0/16"
    service_cidrs       = ["10.0.0.0/16"]
    pod_cidr            = "10.10.240.0/20"
    pod_cidrs           = ["10.10.240.0/20"]
  }

  default_node_pool {
    name                         = "systemnp"
    temporary_name_for_rotation  = "sysnptmp"
    vm_size                      = "Standard_D2s_v5"
    os_sku                       = "Ubuntu" # "AzureLinux"
    auto_scaling_enabled         = true
    node_count                   = 2
    min_count                    = 1
    max_count                    = 5
    max_pods                     = 110
    vnet_subnet_id               = var.snet_aks_id
    pod_subnet_id                = null
    os_disk_type                 = "Managed" # "Ephemeral" # 
    ultra_ssd_enabled            = false
    only_critical_addons_enabled = true # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3]
    scale_down_mode              = "Deallocate" # "Delete" # Deallocate
    workload_runtime             = "OCIContainer"
    kubelet_disk_type            = "OS" # "Temporary" # 
    node_public_ip_enabled       = false
    host_encryption_enabled      = false
    fips_enabled                 = false
    tags                         = var.tags
  }

  identity {
    type         = "UserAssigned" # "SystemAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity-aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.identity-kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.identity-kubelet.principal_id # there is no object_id
    user_assigned_identity_id = azurerm_user_assigned_identity.identity-kubelet.id
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = null # [azuread_group.aks_admins.0.object_id]
    tenant_id              = var.tenant_id
  }

  web_app_routing {
    dns_zone_ids = []
  }

  api_server_access_profile {
    authorized_ip_ranges = null
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

  # confidential_computing {
  #   sgx_quote_helper_enabled = false
  # }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  storage_profile {
    file_driver_enabled         = true
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    snapshot_controller_enabled = true
    # disk_driver_version         = "v2" # not yet available
  }

  oms_agent {
    msi_auth_for_monitoring_enabled = true
    log_analytics_workspace_id      = var.log_analytics_workspace_id
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = [2, 8]
    }
  }

  maintenance_window_auto_upgrade {
    frequency    = "Weekly" # AbsoluteMonthly, RelativeMonthly
    interval     = 1
    duration     = 9        # between 4 to 24 hours
    day_of_week  = "Monday" # Tuesday, Wednesday, Thurday, Friday, Saturday and Sunday
    day_of_month = null
    utc_offset   = "+01:00"
    start_date   = "2025-01-01T00:00:00Z"
    start_time   = "02:00"

    not_allowed {
      start = "2025-01-01T00:00:00Z"
      end   = "2025-01-02T00:00:00Z"
    }
  }

  maintenance_window_node_os {
    frequency    = "Weekly" # AbsoluteMonthly, RelativeMonthly
    interval     = 1
    duration     = 9        # between 4 to 24 hours
    day_of_week  = "Monday" # Tuesday, Wednesday, Thurday, Friday, Saturday and Sunday
    day_of_month = null
    utc_offset   = "+01:00"
    start_date   = "2025-01-01T00:00:00Z"
    start_time   = "02:00"

    not_allowed {
      start = "2025-01-01T00:00:00Z"
      end   = "2025-01-02T00:00:00Z"
    }
  }

  workload_autoscaler_profile {
    keda_enabled                    = true
    vertical_pod_autoscaler_enabled = false
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.upgrade_settings,
      default_node_pool.0.node_count,
      api_server_access_profile
    ]
  }

  depends_on = [
    azurerm_role_assignment.private-dns-zone-contributor,
    azurerm_role_assignment.contributor,
    azurerm_role_assignment.managed-identity-operator,
    azurerm_role_assignment.network-contributor
  ]
}

resource "terraform_data" "aks-get-credentials" {
  triggers_replace = [
    azurerm_kubernetes_cluster.aks.id
  ]

  provisioner "local-exec" {
    command = "az aks get-credentials -n ${azurerm_kubernetes_cluster.aks.name} -g ${azurerm_kubernetes_cluster.aks.resource_group_name} --overwrite-existing"
  }
}
