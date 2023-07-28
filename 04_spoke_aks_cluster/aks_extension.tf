# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension

# resource "azurerm_kubernetes_cluster_extension" "flux" {
#   name           = "flux"
#   cluster_id     = azurerm_kubernetes_cluster.aks.id
#   extension_type = "microsoft.flux" # dapr, azureml
# }

resource "azurerm_kubernetes_cluster_extension" "extension_flux" {
  count          = 0
  name           = "extension-flux"
  cluster_id     = azurerm_kubernetes_cluster.aks.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "flux_config" {
  count      = 0
  name       = "flux-config"
  cluster_id = azurerm_kubernetes_cluster.aks.id
  namespace  = "flux"

  git_repository {
    url             = "https://github.com/Azure/arc-k8s-demo"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "kustomization-1"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.extension_flux[0]
  ]
}
