resource "azurerm_role_assignment" "current_user_aks_admin" {
  count                            = var.enable_aks_admin_rbac ? 1 : 0
  scope                            = azurerm_kubernetes_cluster.aks.id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = data.azuread_client_config.current.object_id
  skip_service_principal_aad_check = false

  timeouts {
    create = "2m"
    delete = "2m"
  }
}