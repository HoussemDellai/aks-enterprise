resource azuread_application" "app_velero" {
  display_name = "spn_velero"
}

resource azuread_service_principal" "spn_velero" {
  application_id = azuread_application.app_velero.application_id
}

resource azuread_service_principal_password" "password_spn_velero" {
  service_principal_id = azuread_service_principal.spn_velero.id
}

resource azurerm_role_assignment" "spn_velero_aks_node_rg" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, data.azurerm_kubernetes_cluster.aks.0.node_resource_group)
  principal_id         = azuread_service_principal.spn_velero.object_id
  role_definition_name = "Contributor"
}

resource azurerm_role_assignment" "spn_velero_backup_storage" {
  scope                = azurerm_storage_account.aks_backups.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

resource azurerm_role_assignment" "spn_velero_backup_storage_key_operator" {
  scope                = azurerm_storage_account.aks_backups.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

resource azurerm_role_assignment" "spn_velero_backup_rg" {
  scope                = azurerm_resource_group.aks_backups.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.spn_velero.object_id
}