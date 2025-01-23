output "aks" {
  value = {
    id = azurerm_kubernetes_cluster.aks.id
  }
}
