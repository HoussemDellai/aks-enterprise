# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_trusted_access_role_binding
# resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "trusted_access" {
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
#   name                  = "trusted-access"
#   roles                 = "example-value"
#   source_resource_id    = azurerm_machine_learning_workspace.example.id
# }