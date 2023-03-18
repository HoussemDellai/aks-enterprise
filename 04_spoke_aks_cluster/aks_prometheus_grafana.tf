resource "null_resource" "aks_enable_azuremonitormetrics" {
  count = var.enable_grafana_prometheus ? 1 : 0
  
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT

    az aks update --enable-azuremonitormetrics `
                  -g ${azurerm_kubernetes_cluster.aks.resource_group_name} `
                  -n ${azurerm_kubernetes_cluster.aks.name} `
                  --azure-monitor-workspace-resource-id ${data.terraform_remote_state.spoke_aks.outputs.prometheus.id}
                  # --grafana-resource-id ${data.terraform_remote_state.spoke_aks.outputs.grafana.id}

    EOT
  }

  triggers = {
    "key" = "value1"
    # trigger = timestamp()
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_kubernetes_cluster_node_pool.poolapps,
    azurerm_kubernetes_cluster_node_pool.poolspot
  ]
}