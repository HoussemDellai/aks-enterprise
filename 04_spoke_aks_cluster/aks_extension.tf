# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension

# resource "azurerm_kubernetes_cluster_extension" "flux" {
#   name           = "flux"
#   cluster_id     = azurerm_kubernetes_cluster.aks.id
#   extension_type = "microsoft.flux" # dapr, azureml
# }