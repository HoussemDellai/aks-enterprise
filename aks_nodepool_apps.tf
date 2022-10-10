
resource "azurerm_kubernetes_cluster_node_pool" "poolapps" {
  count                  = var.enable_nodepool_apps ? 1 : 0
  name                   = "poolapps"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.id
  vm_size                = "Standard_D2ds_v5" # "Standard_D4pls_v5" # "Standard_D4s_v5" #  # "Standard_D2as_v5" doesn't support Ephemeral disk
  node_count             = 0                  # 1
  enable_auto_scaling    = true
  min_count              = 0 # 1
  max_count              = 1 # 9
  zones                  = [1, 2, 3]
  mode                   = "User"
  orchestrator_version   = var.kubernetes_version
  os_type                = "Linux"
  enable_host_encryption = false
  enable_node_public_ip  = false
  max_pods               = 110
  os_disk_size_gb        = 60
  os_disk_type           = "Ephemeral" # "Managed" # 
  os_sku                 = "Ubuntu"    # "CBLMariner" #
  fips_enabled           = false
  vnet_subnet_id         = azurerm_subnet.subnet_nodes.id
  pod_subnet_id          = azurerm_subnet.subnet_pods.id
  scale_down_mode        = "Delete" # ScaleDownModeDeallocate
  workload_runtime       = "OCIContainer"
  message_of_the_day     = null      #TODO "Hello from Azure AKS cluster!"
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