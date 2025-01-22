resource "azurerm_kubernetes_cluster_node_pool" "poolapps" {
  for_each                = var.nodepools_user
  name                    = each.key
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks.id
  vm_size                 = each.value.vm_size # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "Standard_D4pls_v5" # "Standard_D4s_v5" #  # "Standard_D2as_v5" doesn't support Ephemeral disk
  auto_scaling_enabled    = true
  node_count              = 1
  min_count               = 1
  max_count               = 3
  zones                   = [1, 2, 3] # []
  mode                    = "User"
  orchestrator_version    = azurerm_kubernetes_cluster.aks.kubernetes_version
  os_type                 = "Linux"
  host_encryption_enabled = false
  node_public_ip_enabled  = false
  max_pods                = 110
  os_disk_size_gb         = 60
  os_disk_type            = "Managed" # "Ephemeral"
  os_sku                  = each.value.os_sku       # "Ubuntu"    # "CBLMariner" #
  fips_enabled            = false
  vnet_subnet_id          = var.snet_aks_id
  scale_down_mode         = "Delete"       # ScaleDownModeDeallocate
  workload_runtime        = "OCIContainer" # WasmWasi
  priority                = "Regular"      # "Spot"
  # pod_subnet_id           = var.aks_network_plugin == var.network_plugin_mode == "overlay" ? null : azurerm_subnet.subnet_pods_user_nodepool[each.key].id
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
    ignore_changes = [
      node_count,
      node_taints
    ]
  }

  tags = var.tags
}
