resource "null_resource" "connect_to_aks" {
  count = var.enable_aks_cluster ? 1 : 0

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az aks get-credentials -g ${azurerm_kubernetes_cluster.aks.0.resource_group_name} `
                             -n ${azurerm_kubernetes_cluster.aks.0.name} `
                             --overwrite-existing

      kubelogin convert-kubeconfig -l azurecli

      kubectl get nodes
    EOT
  }

  triggers = {
    "key" = "value2"
    # trigger = timestamp()
  }

  depends_on = [
    azurerm_kubernetes_cluster_node_pool.poolapps[0],
    azurerm_kubernetes_cluster_node_pool.poolspot[0]
  ]
}

# resource "null_resource" "enable_aks_addons" {
#   count = var.enable_aks_cluster ? 1 : 0

#   provisioner "local-exec" {
#     command = <<-EOT
#       az aks update -g ${azurerm_kubernetes_cluster.aks.0.resource_group_name} -n ${azurerm_kubernetes_cluster.aks.0.name} --enable-image-cleaner
#     EOT
#   }

#   depends_on = [
#     null_resource.connect_to_aks[0]
#   ]

#   #   triggers = {
#   #     aks_cluster = join(",", azurerm_kubernetes_cluster.aks.*.id)
#   #   }
# }

# resource "null_resource" "enable_aks_vnet_integration" {
#   count = var.enable_aks_cluster && var.enable_apiserver_vnet_integration ? 1 : 0

#   provisioner "local-exec" {
#     interpreter = ["PowerShell", "-Command"]
#     command     = <<-EOT
#       az aks update -g ${azurerm_kubernetes_cluster.aks.0.resource_group_name} `
#                     -n ${azurerm_kubernetes_cluster.aks.0.name} `
#                     --enable-apiserver-vnet-integration `
#                     --apiserver-subnet-id ${azurerm_subnet.subnet_apiserver.0.id}
#     EOT
#   }

#   depends_on = [
#     null_resource.connect_to_aks[0]
#   ]

#   #   triggers = {
#   #     aks_cluster = join(",", azurerm_kubernetes_cluster.aks.*.id)
#   #   }
# }

# resource "null_resource" "install_helm_charts" {
#   count = var.enable_aks_cluster ? 1 : 0

#   provisioner "local-exec" {
#     interpreter = ["PowerShell", "-Command"]
#     command     = <<-EOT
#       .\02_k8s_platforms\install_helm_charts.ps1
#     EOT
#   }

#   triggers = {
#     "key" = "value3"
#     # trigger = timestamp()
#   }

#   depends_on = [
#     null_resource.connect_to_aks[0]
#   ]
# }
