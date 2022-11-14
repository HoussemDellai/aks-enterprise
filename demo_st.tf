resource "azurerm_subnet" "subnet_nodes_tenant_01" {
  name                 = "subnet-nodes-tenant-01"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = ["10.1.10.0/24"]
}

resource "azurerm_subnet" "subnet_pods_tenant_01" {
  name                 = "subnet-pods-tenant-01"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_app.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_app.resource_group_name
  address_prefixes     = ["10.1.11.0/24"]

  # src: https://github.com/hashicorp/terraform-provider-azurerm/blob/4ea5f92ccc27a75807d704f6d66d53a6c31459cb/internal/services/containers/kubernetes_cluster_node_pool_resource_test.go#L1433
  delegation {
    name = "aks-delegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "subnetnodes_tenant_01_assoc" {
  nat_gateway_id = azurerm_nat_gateway.natgw.0.id
  subnet_id      = azurerm_subnet.subnet_nodes_tenant_01.id
}

# mariner nodepool
resource "azurerm_kubernetes_cluster_node_pool" "pool_tenant_01" {
  count                  = var.enable_nodepool_apps && var.enable_aks_cluster ? 1 : 0
  name                   = "pooltenant01"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.0.id
  vm_size                = "Standard_D2pds_v5" # "Standard_D2ds_v5" # "Standard_D4pls_v5" # "Standard_D4s_v5" #  # "Standard_D2as_v5" doesn't support Ephemeral disk
  node_count             = 0                   # 1
  enable_auto_scaling    = true
  min_count              = 0 # 1
  max_count              = 5
  zones                  = [1, 2, 3]
  mode                   = "User"
  orchestrator_version   = var.kubernetes_version
  os_type                = "Linux"
  enable_host_encryption = false
  enable_node_public_ip  = false
  max_pods               = 30
  os_disk_size_gb        = 60
  os_disk_type           = "Ephemeral" # "Managed" # 
  os_sku                 = "Mariner"   # "Ubuntu"    # 
  fips_enabled           = false
  vnet_subnet_id         = azurerm_subnet.subnet_nodes_tenant_01.id
  pod_subnet_id          = azurerm_subnet.subnet_pods_tenant_01.id
  scale_down_mode        = "Delete" # ScaleDownModeDeallocate
  workload_runtime       = "OCIContainer"
  message_of_the_day     = "Hello from Azure AKS cluster!"
  priority               = "Regular" # "Spot"
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

