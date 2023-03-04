resource "azurerm_subnet" "subnet_nodes" {
  name                 = "subnet-nodes"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_nodes
}

resource "azurerm_subnet" "subnet_pods" {
  name                 = "subnet-pods"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_pods

  # src: https://github.com/hashicorp/terraform-provider-azurerm/blob/4ea5f92ccc27a75807d704f6d66d53a6c31459cb/internal/services/containers/kubernetes_cluster_node_pool_resource_test.go#L1433
  delegation {
    name = "aks-delegation"
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
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_apiserver_vnetint

  delegation {
    name = "aks-delegation"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  # count                               = var.enable_aks_cluster ? 1 : 0
  name                                = "aks-cluster"
  resource_group_name                 = azurerm_resource_group.rg_spoke_aks.name
  location                            = var.resources_location
  kubernetes_version                  = var.kubernetes_version
  sku_tier                            = "Free" # "Paid"
  dns_prefix                          = var.aks_dns_prefix
  node_resource_group                 = var.rg_spoke_aks_nodes
  private_cluster_enabled             = var.enable_private_cluster
  private_cluster_public_fqdn_enabled = false
  public_network_access_enabled       = true
  role_based_access_control_enabled   = true
  azure_policy_enabled                = true
  open_service_mesh_enabled           = true
  local_account_disabled              = true
  run_command_enabled                 = true
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = 24 # in the range (24 - 2160)
  private_dns_zone_id                 = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
  tags                                = var.tags
  automatic_channel_upgrade           = "node-image" # none, patch, rapid, node-image, stable

  api_server_access_profile {
    authorized_ip_ranges     = var.enable_private_cluster ? null : ["0.0.0.0/0"] # when private cluster, this should not be enabled
    subnet_id                = azurerm_subnet.subnet_apiserver.0.id
    vnet_integration_enabled = var.enable_apiserver_vnet_integration
  }

  default_node_pool {
    name                         = "poolsystem"
    node_count                   = 1
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 110
    vm_size                      = "Standard_D2s_v5" # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "standard_d2pds_v5"
    os_disk_size_gb              = var.aks_agent_os_disk_size
    os_disk_type                 = "Managed" # "Ephemeral" # 
    ultra_ssd_enabled            = false
    os_sku                       = "Ubuntu"                                        # Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022
    only_critical_addons_enabled = var.enable_system_nodepool_only_critical_addons # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3]                                       # []
    vnet_subnet_id               = azurerm_subnet.subnet_nodes.id
    pod_subnet_id                = azurerm_subnet.subnet_pods.id
    scale_down_mode              = "Delete" # ScaleDownModeDeallocate
    workload_runtime             = "OCIContainer"
    kubelet_disk_type            = "OS" # "Temporary" # 
    enable_node_public_ip        = false
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
    # network_plugin_mode = "Overlay"
    # ebpf_data_plane     = "cilium"
    # network_mode        = "bridge"               # " transparent"
    network_plugin     = var.aks_network_plugin # "kubenet", "azure", "none"
    network_policy     = "calico"               # "azure" 
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.cidr_aks_docker_bridge
    service_cidr       = var.cidr_aks_service
    outbound_type      = var.aks_outbound_type # "userAssignedNATGateway loadBalancer" # userDefinedRouting, managedNATGateway
    load_balancer_sku  = "standard"            # "basic"
    pod_cidr           = null                  # can only be set when network_plugin is set to kubenet
    # pod_cidr    = var.aks_network_plugin == "kubenet" ? var.cidr_subnet_pods : null # only set when network_plugin is set to kubenet
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
      gateway_id = azurerm_application_gateway.appgw.0.id
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
      log_analytics_workspace_id = data.terraform_remote_state.management.0.outputs.log_analytics_workspace.id # azurerm_log_analytics_workspace.workspace.id
    }
  }
  # oms_agent {
  #   log_analytics_workspace_id = var.enable_monitoring ? azurerm_log_analytics_workspace.workspace.0.id : null # doesn't work when resource disabled
  # }
  # microsoft_defender {
  #   log_analytics_workspace_id = ""
  # }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = [2, 8]
    }
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  # linux_profile {
  #   admin_username = var.vm_user_name
  #   ssh_key {
  #     key_data = file(var.public_ssh_key_path)
  #   }
  # }

  # monitor_metrics {
  #   annotations_allowed = []
  #   labels_allowed = []
  # }

  # storage_profile { #todo
  #   file_driver_enabled         = true
  #   blob_driver_enabled         = true
  #   disk_driver_enabled         = true
  #   disk_driver_version         = "v2"
  #   snapshot_controller_enabled = true
  # }

  # web_app_routing {
  #   dns_zone_id = null #TODO
  # }

  depends_on = [
    azurerm_virtual_network.vnet_spoke_aks,
    azurerm_application_gateway.appgw
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

# az aks update -n <cluster-name> \
#     -g <resource-group> \
#     --enable-apiserver-vnet-integration \
#     --apiserver-subnet-id <apiserver-subnet-resource-id>
# resource azapi_update_resource aks_api_vnet_integration {
#   count       = var.enable_apiserver_vnet_integration ? 1 : 0
#   type        = "Microsoft.ContainerService/managedClusters@2022-06-02-preview"
#   resource_id = azurerm_kubernetes_cluster.aks.0.id

#   # "properties": {
#   #   "apiServerAccessProfile": {
#   #       "enablePrivateCluster": false,
#   #       "enableVnetIntegration": true,
#   #       "subnetId": "[concat(parameters('virtualNetworks_vnet_spoke_aks_externalid'), '/subnets/subnet-apiserver')]"
#   #   },
#   # }
#   body = jsonencode({
#     properties = {
#       apiServerAccessProfile = {
#         enablePrivateCluster  = var.enable_private_cluster,
#         enableVnetIntegration = var.enable_apiserver_vnet_integration,
#         subnetId              = azurerm_subnet.subnet_apiserver.0.id
#       },
#     }
#   })

#   depends_on = []
# }

data "azurerm_kubernetes_service_versions" "aks" {
  location = var.resources_location
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.aks.latest_version
}