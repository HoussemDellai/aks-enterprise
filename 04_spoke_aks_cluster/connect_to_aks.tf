resource "terraform_data" "aks-get-credentials" {
  triggers_replace = [
    azurerm_kubernetes_cluster.aks.id
  ]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az aks get-credentials -g ${azurerm_kubernetes_cluster.aks.resource_group_name} `
                             -n ${azurerm_kubernetes_cluster.aks.name} `
                             --overwrite-existing

      kubelogin convert-kubeconfig -l azurecli

      kubectl get nodes
    EOT
  }

  depends_on = [
    azurerm_kubernetes_cluster_node_pool.poolapps[0],
    azurerm_kubernetes_cluster_node_pool.poolspot[0]
  ]
}