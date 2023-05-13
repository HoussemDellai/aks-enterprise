#----------------------------------------------------------------------------------------------------#
# Resource Group to store disk snapshots + Storage Account to store backup configuration files       #
#----------------------------------------------------------------------------------------------------#

resource "azurerm_resource_group" "aks_backups" {
  # for_each = var.enable_velero_backups ? [] : []
  # count = var.enable_velero_backups ? 1 : 0
  name     = var.backups_rg_name
  location = var.backups_region
  tags     = var.tags
}

resource "azurerm_storage_account" "aks_backups" {
  # for_each = var.enable_velero_backups ? [] : []
  # count = var.enable_velero_backups ? 1 : 0
  name                      = var.storage_account_name_backup
  resource_group_name       = azurerm_resource_group.aks_backups.name
  location                  = azurerm_resource_group.aks_backups.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  access_tier               = "Hot"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  tags                      = var.tags
}

resource "azurerm_storage_container" "aks_backups" {
  # for_each = var.enable_velero_backups ? [] : []
  # count = var.enable_velero_backups ? 1 : 0
  name                  = "velero"
  storage_account_name  = azurerm_storage_account.aks_backups.name
  container_access_type = "private"
}