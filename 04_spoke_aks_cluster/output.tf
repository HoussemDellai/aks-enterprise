output "rg" {
  value = {
    name = azurerm_resource_group.rg.name
  }
}

data "azurerm_kubernetes_service_versions" "aks" {
  location = var.location
}

output "aks_latest_version" {
  value = data.azurerm_kubernetes_service_versions.aks.latest_version
}
