resource "azurerm_kubernetes_cluster" "aks" {
  name                                = var.aks_name
  resource_group_name                 = azurerm_resource_group.rg_aks.name
  location                            = var.resources_location
  kubernetes_version                  = var.kubernetes_version
  dns_prefix                          = var.aks_dns_prefix
  node_resource_group                 = var.rg_aks_nodes
  private_cluster_enabled             = var.enable_private_cluster
  private_cluster_public_fqdn_enabled = false # true # 
  public_network_access_enabled       = true  # false #
  role_based_access_control_enabled   = true
  sku_tier                            = "Free" # "Paid"
  azure_policy_enabled                = true
  open_service_mesh_enabled           = true
  local_account_disabled              = true
  oidc_issuer_enabled                 = true
  run_command_enabled                 = true
  private_dns_zone_id                 = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_aks.0.id : null
  tags                                = var.tags
  # api_server_authorized_ip_ranges     = ["0.0.0.0/0"] # when private cluster, this should not be enabled
  # automatic_channel_upgrade           = # none, patch, rapid, node-image, stable

  # linux_profile {
  #   admin_username = var.vm_user_name
  #   ssh_key {
  #     key_data = file(var.public_ssh_key_path)
  #   }
  # }

  default_node_pool {
    name                         = "poolsystem"
    node_count                   = 1
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 2
    max_pods                     = 110
    vm_size                      = var.aks_agent_vm_size # "Standard_D2ds_v5"
    os_disk_size_gb              = var.aks_agent_os_disk_size
    os_disk_type                 = "Ephemeral" # "Managed"
    os_sku                       = "Ubuntu"    # "CBLMariner" #
    only_critical_addons_enabled = true        # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3]
    tags                         = var.tags
    vnet_subnet_id               = azurerm_subnet.subnet_nodes.id
    pod_subnet_id                = azurerm_subnet.subnet_pods.id
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

  network_profile {
    network_plugin     = var.aks_network_plugin # "kubenet", "azure", "transparent"
    network_policy     = "calico"               # "azure" 
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.cidr_aks_docker_bridge
    service_cidr       = var.cidr_aks_service
    outbound_type      = var.aks_outbound_type # "userAssignedNATGateway" "loadBalancer" # userDefinedRouting, managedNATGateway
    load_balancer_sku  = "standard"            # "basic"
    # pod_cidr           = var.aks_network_plugin == "kubenet" ? var.cidr_subnet_pods : null # null # can only be set when network_plugin is set to kubenet

    dynamic "load_balancer_profile" {
      for_each = var.aks_outbound_type == "loadBalancer" ? ["any_value"] : []
      content {
        idle_timeout_in_minutes   = 30
        managed_outbound_ip_count = 2
      }
    }

    dynamic "nat_gateway_profile" {
      for_each = var.aks_outbound_type == "userAssignedNATGateway" ? ["any_value"] : []
      # count = var.enable_container_insights ? 1 : 0 # count couldn't be used inside nested block
      content {
        idle_timeout_in_minutes   = 4 # Must be between 4 and 120 inclusive. Defaults to 4
        managed_outbound_ip_count = 2 # Must be between 1 and 100 inclusive
      }
    }
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.enable_aks_admin_group ? [azuread_group.aks_admins.0.object_id] : null
    tenant_id              = var.enable_aks_admin_group ? data.azurerm_subscription.current.tenant_id : null
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
    for_each = var.enable_container_insights ? ["any_value"] : []
    # count = var.enable_container_insights ? 1 : 0 # count couldn't be used inside nested block
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
    }
  }
  # oms_agent {
  #   log_analytics_workspace_id = var.enable_container_insights ? azurerm_log_analytics_workspace.workspace.0.id : null # doesn't work when resource disabled
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

  depends_on = [
    azurerm_virtual_network.vnet_spoke,
    azurerm_application_gateway.appgw
  ]

  lifecycle {
    # prevent_destroy       = true
    # create_before_destroy = true
    ignore_changes = [
      # all, # ignore all attributes
      default_node_pool[0].node_count,
      microsoft_defender,
      # oms_agent
      network_profile.0.nat_gateway_profile
    ]
  }
}

# az aks update -n <cluster-name> \
#     -g <resource-group> \
#     --enable-apiserver-vnet-integration \
#     --apiserver-subnet-id <apiserver-subnet-resource-id>
resource "azapi_update_resource" "aks_api_vnet_integration" {
  count       = var.enable_apiserver_vnet_integration ? 1 : 0
  type        = "Microsoft.ContainerService/managedClusters@2022-06-02-preview"
  resource_id = azurerm_kubernetes_cluster.aks.id

  # "properties": {
  #   "apiServerAccessProfile": {
  #       "enablePrivateCluster": false,
  #       "enableVnetIntegration": true,
  #       "subnetId": "[concat(parameters('virtualNetworks_vnet_spoke_aks_externalid'), '/subnets/subnet-apiserver')]"
  #   },
  # }
  body = jsonencode({
    properties = {
      apiServerAccessProfile = {
        enablePrivateCluster  = var.enable_private_cluster,
        enableVnetIntegration = var.enable_apiserver_vnet_integration,
        subnetId              = azurerm_subnet.subnet_apiserver.0.id
      },
    }
  })

  depends_on = []
}

# https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/main.tf
resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_aks" {
  count                      = var.enable_container_insights ? 1 : 0
  name                       = "diagnostic-settings"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "cloud-controller-manager"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "guard"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "csi-azuredisk-controller"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "csi-azurefile-controller"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "csi-snapshot-controller"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}