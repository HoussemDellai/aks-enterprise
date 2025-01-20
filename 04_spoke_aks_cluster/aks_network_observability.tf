resource "azapi_update_resource" "aks_enable_network_observability" {
  type        = "Microsoft.ContainerService/managedClusters@2024-09-01"
  resource_id = azurerm_kubernetes_cluster.aks.id

  body = {
    properties = {
      networkProfile = {
        advancedNetworking = {
          enabled = true
          observability = {
            enabled = true
          }
          security = {
            enabled = true
          }
        }
      }
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_kubernetes_cluster_node_pool.poolapps,
    azurerm_kubernetes_cluster_node_pool.poolspot
  ]
}
