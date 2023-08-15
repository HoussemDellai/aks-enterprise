resource "azurerm_subnet" "subnet_nodes_user_nodepool_spot" {
  count                = var.enable_nodepool_spot ? 1 : 0
  name                 = "subnet-nodes-spot"
  virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name # azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name  # azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = ["10.1.20.0/24"]
}

resource "azurerm_subnet" "subnet_pods_user_nodepool_spot" {
  count                = var.enable_nodepool_spot ? 1 : 0
  name                 = "subnet-pods-spot"
  virtual_network_name = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.virtual_network_name # azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.resource_group_name  # azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = ["10.1.21.0/24"]

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

resource "azurerm_kubernetes_cluster_node_pool" "poolspot" {
  count                  = var.enable_nodepool_spot ? 1 : 0
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.id
  name                   = "poolspot"
  mode                   = "User"
  priority               = "Spot"
  eviction_policy        = "Delete"
  spot_max_price         = -1 # note: this is the "maximum" price
  os_type                = "Linux"
  vm_size                = "Standard_D2pds_v5" # "Standard_D2ds_v5" # "Standard_DS2_v2" # 
  os_disk_type           = "Ephemeral"         # https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks#size-requirements
  os_sku                 = "Ubuntu"            # "CBLMariner" # 
  node_count             = 0
  enable_auto_scaling    = true
  max_count              = 1 # 3
  min_count              = 0 # 1
  fips_enabled           = false
  vnet_subnet_id         = azurerm_subnet.subnet_nodes_user_nodepool_spot.0.id
  pod_subnet_id          = var.aks_network_plugin == "kubenet" || var.network_plugin_mode == "overlay" ? null : azurerm_subnet.subnet_pods_user_nodepool_spot.0.id
  enable_host_encryption = false
  enable_node_public_ip  = false
  max_pods               = 110
  os_disk_size_gb        = 60
  zones                  = []   # [1, 2, 3]
  node_taints            = null # "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"

  lifecycle {
    # create_before_destroy = true
    ignore_changes = [
      node_count,
      node_taints
    ]
  }

  tags = var.tags
}
