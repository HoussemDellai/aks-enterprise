# module "velero" {
#   source = "./modules/velero"

#   providers = {
#     kubernetes = kubernetes.aks-module
#     helm       = helm.aks-module
#   }

#   backups_region                = var.backups_region
#   backups_rg_name               = azurerm_resource_group.aks_backups.name
#   backups_stracc_name           = azurerm_storage_account.aks_backups.name
#   backups_stracc_container_name = azurerm_storage_container.aks_backups.name
#   aks_nodes_resource_group_name = data.azurerm_kubernetes_cluster.aks_cluster.node_resource_group

#   velero_namespace                 = "velero"
#   velero_chart_repository          = "https://vmware-tanzu.github.io/helm-charts"
#   velero_chart_version             = "2.29.3"
#   velero_restore_mode_only         = "false"
#   velero_default_volumes_to_restic = "true" #use restic (file copy) by default for backups (no volume snapshots)

#   velero_sp_tenantID     = data.azurerm_client_config.current.tenant_id
#   velero_sp_clientID     = azuread_service_principal.spn_velero.application_id
#   velero_sp_clientSecret = azuread_service_principal_password.password_spn_velero.value

#   velero_values = var.velero_values

#   depends_on = [azurerm_kubernetes_cluster.aks]
# }
