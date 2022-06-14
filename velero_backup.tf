resource "azuread_application" "app_velero" {
  display_name = var.spn_name
}

resource "azuread_service_principal" "spn_velero" {
  application_id = azuread_application.app_velero.application_id
}

resource "azuread_service_principal_password" "password_spn_velero" {
  service_principal_id = azuread_service_principal.spn_velero.id
}

resource "azurerm_role_assignment" "spn_velero_aks_node_rg" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, azurerm_kubernetes_cluster.aks.node_resource_group)
  principal_id         = azuread_service_principal.spn_velero.object_id
  role_definition_name = "Contributor"
}

resource "azurerm_role_assignment" "spn_velero_backup_storage" {
  scope                = azurerm_storage_account.aks_backups.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

resource "azurerm_role_assignment" "spn_velero_backup_storage_key_operator" {
  scope                = azurerm_storage_account.aks_backups.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

resource "azurerm_role_assignment" "spn_velero_backup_rg" {
  scope                = azurerm_resource_group.aks_backups.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

module "velero" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  source = "./modules/velero"

  providers = {
    kubernetes = kubernetes.aks-module
    helm       = helm.aks-module
  }

  backups_region                = var.backups_region
  backups_rg_name               = azurerm_resource_group.aks_backups.name
  backups_stracc_name           = azurerm_storage_account.aks_backups.name
  backups_stracc_container_name = azurerm_storage_container.aks_backups.name
  aks_nodes_resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group

  velero_namespace                 = "velero"
  velero_chart_repository          = "https://vmware-tanzu.github.io/helm-charts"
  velero_chart_version             = "2.29.3"
  velero_restore_mode_only         = "false"
  velero_default_volumes_to_restic = "true" #use restic (file copy) by default for backups (no volume snapshots)

  velero_sp_tenantID     = data.azurerm_client_config.current.tenant_id
  velero_sp_clientID     = azuread_service_principal.spn_velero.application_id
  velero_sp_clientSecret = azuread_service_principal_password.password_spn_velero.value

  velero_values = var.velero_values
}
