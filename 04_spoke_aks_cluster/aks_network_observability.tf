resource "azapi_update_resource" "aks_enable_network_observability" {
  type        = "Microsoft.ContainerService/managedClusters@2023-05-02-preview"
  resource_id = azurerm_kubernetes_cluster.aks.id

  body = jsonencode({
    properties = {
      networkProfile = {
        monitoring = {
          enabled = true
        }
      }
    }
  })
}

# resource "null_resource" "aks_enable_network_observability" {
#   count = var.enable_grafana_prometheus ? 1 : 0

#   provisioner "local-exec" {
#     interpreter = ["PowerShell", "-Command"]
#     on_failure  = continue # fail
#     when        = create
#     command     = <<-EOT

#       az aks update --enable-network-observability  `
#                     -g ${azurerm_kubernetes_cluster.aks.resource_group_name} `
#                     -n ${azurerm_kubernetes_cluster.aks.name}
#     EOT
#   }

#   # provisioner "local-exec" {
#   #   interpreter = ["PowerShell", "-Command"]
#   #   on_failure   = continue # fail
#   #   when        = destroy
#   #   command     = <<-EOT

#   #     az aks update --disable-azuremonitormetrics `
#   #                   -g ${azurerm_kubernetes_cluster.aks.resource_group_name} `
#   #                   -n ${azurerm_kubernetes_cluster.aks.name}
#   #   EOT
#   # }

#   triggers = {
#     "key" = "value1"
#     # trigger = timestamp()
#   }

#   depends_on = [
#     azurerm_kubernetes_cluster.aks,
#     azurerm_kubernetes_cluster_node_pool.poolapps,
#     azurerm_kubernetes_cluster_node_pool.poolspot,
#     null_resource.aks_enable_azuremonitormetrics
#   ]
# }
