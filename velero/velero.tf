data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_kubernetes_cluster.aks]
}

resource "azurerm_storage_account" "storaccbackup" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = "${lower(var.project)}${lower(var.stage)}storaccbackup"
  resource_group_name      = var.resource_group
  min_tls_version          = "TLS1_2"
  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "2.0"
      retention_policy_days = 14
    }
  }
}

resource "azurerm_storage_container" "storcontbackup" {
  name                 = "${lower(var.project)}${lower(var.stage)}storcontbackup"
  storage_account_name = azurerm_storage_account.storaccbackup.name
}

resource "azurerm_role_assignment" "storage-blob-data-contributor" {
  count                = var.create_role_assignment ? 1 : 0
  principal_id         = var.backup_sp_objectid == "" ? var.backup_sp_id : var.backup_sp_objectid
  scope                = azurerm_storage_account.storaccbackup.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "kubernetes_namespace" "velero" {
  metadata {
    name = "velero"
  }
}

resource "helm_release" "velero" {
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = var.velero_version
  namespace  = kubernetes_namespace.velero.metadata[0].name

  set {
    name  = "configuration.provider"
    value = "azure"
  }
  set {
    name  = "configuration.backupStorageLocation.name"
    value = "default"
  }
  set {
    name  = "configuration.backupStorageLocation.bucket"
    value = azurerm_storage_container.storcontbackup.name
  }
  set {
    name  = "configuration.backupStorageLocation.prefix"
    value = "kubernetes"
  }
  set {
    name  = "configuration.backupStorageLocation.config.resourceGroup"
    value = var.resource_group
  }
  set {
    name  = "configuration.backupStorageLocation.config.storageAccount"
    value = azurerm_storage_account.storaccbackup.name
  }
  set {
    name  = "configuration.backupStorageLocation.config.subscriptionId"
    value = var.subscription_id
  }
  set {
    name  = "snapshotsEnabled"
    value = var.snapshots_enabled
  }
  set {
    name  = "credentials.secretContents.cloud"
    value = <<EOF
AZURE_SUBSCRIPTION_ID=${var.subscription_id}
AZURE_TENANT_ID=${var.backup_tenant_id}
AZURE_CLIENT_ID=${var.backup_sp_id}
AZURE_CLIENT_SECRET=${var.backup_sp_secret}
AZURE_RESOURCE_GROUP=${var.resource_group}
AZURE_CLOUD_NAME="AzurePublicCloud"
EOF
  }
  set {
    name  = "initContainers[0].name"
    value = "velero-plugin-for-azure"
  }
  set {
    name  = "initContainers[0].image"
    value = "velero/velero-plugin-for-microsoft-azure:${var.azure_velero_plugin_version}"
  }
  set {
    name  = "initContainers[0].volumeMounts[0].mountPath"
    value = "/target"
  }
  set {
    name  = "initContainers[0].volumeMounts[0].name"
    value = "plugins"
  }
  set {
    name  = "schedules.backup.schedule"
    value = var.schedule
  }
  dynamic "set" {
    for_each = var.include_namespaces
    content {
      name  = "schedules.backup.template.includedNamespaces[${set.key}]"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.exclude_namespaces
    content {
      name  = "schedules.backup.template.excludedNamespaces[${set.key}]"
      value = set.value
    }
  }
  set {
    name  = "schedules.backup.template.ttl"
    value = var.ttl
  }
}