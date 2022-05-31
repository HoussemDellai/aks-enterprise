data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_kubernetes_cluster.aks]
}

# data "azurerm_resource_group" "velero" {
#   name = var.backups_rg_name

#   depends_on = [azurerm_resource_group.rg_aks_backups]
# }

# data "azurerm_storage_account" "velero" {
#   name                = var.backups_stracc_name
#   resource_group_name = var.backups_rg_name

#   depends_on = [azurerm_storage_account.rg_aks_backups]
# }

resource "azuread_application" "app_velero" {
  display_name = "app-velero"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "spn_velero" {
  application_id               = azuread_application.app_velero.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# az ad sp create-for-rbac --name sp-velero-aks1 --role Reader --scopes /subscriptions/{subscriptionId}
resource "azurerm_role_assignment" "spn_velero_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

# resource "azurerm_role_assignment" "spn_velero_aks_node_rg" {
#   scope                = data.azurerm_resource_group.aks_nodes_rg.id
#   principal_id         = azuread_service_principal.spn_velero.object_id
#   role_definition_name = "Contributor"
# }

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
  scope                = azurerm_resource_group.rg_aks_backups.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.spn_velero.object_id
}

resource "azuread_service_principal_password" "spn_velero_password" {
  service_principal_id = azuread_service_principal.spn_velero.object_id
}

module "velero" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  source = "./modules/velero"

  providers = {
    kubernetes = kubernetes.aks-module
    helm       = helm.aks-module
  }

  backups_region                = var.backups_region
  backups_rg_name               = var.backups_rg_name
  backups_stracc_name           = var.backups_stracc_name
  backups_stracc_container_name = var.backups_stracc_container_name
  aks_nodes_resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group

  velero_namespace                 = var.velero_namespace
  velero_chart_repository          = var.velero_chart_repository
  velero_chart_version             = var.velero_chart_version
  velero_values                    = var.velero_values
  velero_restore_mode_only         = "false"
  velero_default_volumes_to_restic = "true" #use restic (file copy) by default for backups (no volume snapshots)


  velero_sp_tenantID     = data.azurerm_client_config.current.tenant_id
  velero_sp_clientID     = azuread_service_principal.spn_velero.application_id
  velero_sp_clientSecret = azuread_service_principal_password.spn_velero_password.value
}