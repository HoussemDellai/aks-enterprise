resource "azurerm_role_assignment" "azure-kubernetes-service-rbac-cluster-admin" {
  scope                            = azurerm_kubernetes_cluster.aks.id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = var.eid_group_aks_admins_object_id
  principal_type                   = "Group" # User, Group and ServicePrincipal
  skip_service_principal_aad_check = true
}
