resource "azurerm_user_assigned_identity" "identity-aks" {
  name                = "identity-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_mi_network_contributor" {
  scope                            = azurerm_virtual_network.vnet.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_mi_operator" {
  scope                            = azurerm_user_assigned_identity.identity-kubelet.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_mi_contributor_aks_rg" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

# resource "azurerm_role_assignment" "aks_mi_contributor_aks_nodes_rg" {
#   scope                            = data.azurerm_resource_group.aks_nodes_rg.id # azurerm_kubernetes_cluster.aks.node_resource_group.id
#   role_definition_name             = "Contributor"
#   principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
#   skip_service_principal_aad_check = true

#   depends_on = [azurerm_kubernetes_cluster.aks]
# }

resource "azurerm_kubernetes_cluster" "aks" {
  name                                = var.aks_name
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = var.resources_location
  kubernetes_version                  = var.kubernetes_version
  dns_prefix                          = var.aks_dns_prefix
  private_cluster_enabled             = false
  node_resource_group                 = var.node_resource_group
  role_based_access_control_enabled   = true
  sku_tier                            = "Free" # "Paid"
  azure_policy_enabled                = true
  open_service_mesh_enabled           = true
  local_account_disabled              = true
  oidc_issuer_enabled                 = true
  private_cluster_public_fqdn_enabled = false
  public_network_access_enabled       = true
  api_server_authorized_ip_ranges     = ["0.0.0.0/0"]
  run_command_enabled                 = true
  # automatic_channel_upgrade           = # none, patch, rapid, node-image, stable

  # linux_profile {
  #   admin_username = var.vm_user_name
  #   ssh_key {
  #     key_data = file(var.public_ssh_key_path)
  #   }
  # }

  default_node_pool {
    name                         = "poolsystem"
    node_count                   = var.aks_agent_count
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 110
    vm_size                      = var.aks_agent_vm_size
    os_disk_size_gb              = var.aks_agent_os_disk_size
    os_disk_type                 = "Ephemeral" # "Managed"
    only_critical_addons_enabled = true        # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3]
    tags                         = var.tags
    vnet_subnet_id               = azurerm_subnet.subnetnodes.id
    pod_subnet_id                = azurerm_subnet.subnetpods.id
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
    network_plugin     = var.aks_network_plugin # "kubenet", "azure" 
    network_policy     = "calico"               # "azure" 
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
    outbound_type      = "loadBalancer" # userDefinedRouting, managedNATGateway, userAssignedNATGateway
    # pod_cidr         = var.aks_subnet_address_prefix # can only be set when network_plugin is set to kubenet
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.aks_admins.object_id]
    tenant_id              = data.azurerm_subscription.current.tenant_id
    # admin_group_object_ids = var.aks_admin_group_object_ids
  }

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.appgw.id
    # other options if we want to allow the AGIC addon to create a new AppGW 
    # and not use an existing one
    # subnet_id    = # link AppGW to specific Subnet
    # gateway_name = # give a name to the generated AppGW
    # subnet_cidr  = # specify the CIDR range for the Subnet that will be created
  }

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

  # oms_agent {
  #   log_analytics_workspace_id = ""
  # }

  # microsoft_defender {
  #   log_analytics_workspace_id = ""
  # }

  tags = var.tags
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_application_gateway.appgw
  ]

  lifecycle {
    # prevent_destroy       = true
    # create_before_destroy = true
    ignore_changes = [
      # all, # ignore all attributes
      default_node_pool[0].node_count,
      microsoft_defender,
      oms_agent
    ]
  }
}

# data "azurerm_resource_group" "aks_nodes_rg" {
#   name = azurerm_kubernetes_cluster.aks.node_resource_group # var.node_resource_group

#   # depends_on = [azurerm_kubernetes_cluster.aks]
# }

resource "azurerm_kubernetes_cluster_node_pool" "appspool" {
  name                   = "poolapps"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.id
  vm_size                = "Standard_D2ds_v5" # "Standard_D2as_v5" doesn't support Ephemeral disk
  node_count             = 1
  zones                  = [1, 2, 3]
  mode                   = "User"
  orchestrator_version   = var.kubernetes_version
  os_type                = "Linux"
  enable_host_encryption = false
  enable_node_public_ip  = false
  max_pods               = 110
  os_disk_size_gb        = 60
  os_disk_type           = "Ephemeral" # "Managed" # 
  enable_auto_scaling    = true
  min_count              = 1
  max_count              = 5
  fips_enabled           = false
  vnet_subnet_id         = azurerm_subnet.subnetnodes.id
  pod_subnet_id          = azurerm_subnet.subnetpods.id
  # priority               = "Spot"
  # eviction_policy        = "Delete"
  # spot_max_price         = 0.5 # note: this is the "maximum" price
  # node_labels = {
  #   "kubernetes.azure.com/scalesetpriority" = "spot"
  # }
  # node_taints = [
  #   "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  # ]

  upgrade_settings {
    max_surge = 3
  }

  lifecycle {
    # create_before_destroy = true
    ignore_changes = [
      node_count,
      node_taints
    ]
  }

  tags = var.tags
}

# resource "azurerm_kubernetes_cluster_node_pool" "poolspot" {
#   kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.id
#   name                   = "poolspot"
#   mode                   = "User"
#   priority               = "Spot"
#   eviction_policy        = "Delete"
#   spot_max_price         = -1 # note: this is the "maximum" price
#   os_type                = "Linux"
#   vm_size                = "Standard_DS2_v2" # "Standard_D2ds_v5"
#   os_disk_type           = "Ephemeral" # https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks#size-requirements
#   node_count             = 0
#   enable_auto_scaling    = true
#   max_count              = 3
#   min_count              = 0
#   fips_enabled           = false
#   vnet_subnet_id         = azurerm_subnet.subnetnodes.id
#   pod_subnet_id          = azurerm_subnet.subnetpods.id
#   enable_host_encryption = false
#   enable_node_public_ip  = false
#   max_pods               = 110
#   os_disk_size_gb        = 60
#   zones                  = [1, 2, 3]
#   # node_taints            = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
#   tags                   = var.tags
# }