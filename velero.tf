# #----------------------------------------------------------------------------------------------------#
# # Resource Group to store disk snapshots + Storage Account to store backup configuration files       #
# #----------------------------------------------------------------------------------------------------#

# resource "azurerm_resource_group" "aks_backups" {
#   name     = var.backups_rg_name
#   location = var.backups_region
#   tags     = var.tags
# }

# resource "azurerm_storage_account" "aks_backups" {
#   name                     = var.storage_account_name_backup
#   resource_group_name      = azurerm_resource_group.aks_backups.name
#   location                 = azurerm_resource_group.aks_backups.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"
#   access_tier              = "Hot"
#   min_tls_version          = "TLS1_2"
#   enable_https_traffic_only = true
#   tags = var.tags
# }

# resource "azurerm_storage_container" "velero" {
#   name                  = "velero"
#   storage_account_name  = azurerm_storage_account.aks_backups.name
#   container_access_type = "private"
# }

# resource "azurerm_role_assignment" "storage-blob-data-contributor" {
#   principal_id         = var.backup_sp_objectid == "" ? var.backup_sp_id : var.backup_sp_objectid
#   scope                = azurerm_storage_account.storaccbackup.id
#   role_definition_name = "Storage Blob Data Contributor"
# }

# resource "kubernetes_namespace" "velero" {
#   metadata {
#     name = "velero"
#   }
# }

# resource "helm_release" "velero" {
#   name       = "velero"
#   repository = "https://vmware-tanzu.github.io/helm-charts"
#   chart      = "velero"
#   version    = var.velero_version
#   namespace  = kubernetes_namespace.velero.metadata[0].name

#   set {
#     name  = "configuration.provider"
#     value = "azure"
#   }
#   set {
#     name  = "configuration.backupStorageLocation.name"
#     value = "default"
#   }
#   set {
#     name  = "configuration.backupStorageLocation.bucket"
#     value = azurerm_storage_container.storcontbackup.name
#   }
#   set {
#     name  = "configuration.backupStorageLocation.prefix"
#     value = "kubernetes"
#   }
#   set {
#     name  = "configuration.backupStorageLocation.config.resourceGroup"
#     value = var.resource_group
#   }
#   set {
#     name  = "configuration.backupStorageLocation.config.storageAccount"
#     value = azurerm_storage_account.storaccbackup.name
#   }
#   set {
#     name  = "configuration.backupStorageLocation.config.subscriptionId"
#     value = var.subscription_id
#   }
#   set {
#     name  = "snapshotsEnabled"
#     value = var.snapshots_enabled
#   }
#   set {
#     name  = "credentials.secretContents.cloud"
#     value = <<EOF
# AZURE_SUBSCRIPTION_ID=${var.subscription_id}
# AZURE_TENANT_ID=${var.backup_tenant_id}
# AZURE_CLIENT_ID=${var.backup_sp_id}
# AZURE_CLIENT_SECRET=${var.backup_sp_secret}
# AZURE_RESOURCE_GROUP=${var.resource_group}
# AZURE_CLOUD_NAME="AzurePublicCloud"
# EOF
#   }
#   set {
#     name  = "initContainers[0].name"
#     value = "velero-plugin-for-azure"
#   }
#   set {
#     name  = "initContainers[0].image"
#     value = "velero/velero-plugin-for-microsoft-azure:${var.azure_velero_plugin_version}"
#   }
#   set {
#     name  = "initContainers[0].volumeMounts[0].mountPath"
#     value = "/target"
#   }
#   set {
#     name  = "initContainers[0].volumeMounts[0].name"
#     value = "plugins"
#   }
#   set {
#     name  = "schedules.backup.schedule"
#     value = var.schedule
#   }
#   dynamic "set" {
#     for_each = var.include_namespaces
#     content {
#       name  = "schedules.backup.template.includedNamespaces[${set.key}]"
#       value = set.value
#     }
#   }
#   dynamic "set" {
#     for_each = var.exclude_namespaces
#     content {
#       name  = "schedules.backup.template.excludedNamespaces[${set.key}]"
#       value = set.value
#     }
#   }
#   set {
#     name  = "schedules.backup.template.ttl"
#     value = var.ttl
#   }
# }