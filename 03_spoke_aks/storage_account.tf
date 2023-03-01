resource "azurerm_storage_account_network_rules" "rules_storage" {
  count                      = var.enable_storage_account ? 1 : 0
  storage_account_id         = azurerm_storage_account.storage.0.id
  default_action             = "Deny"
  bypass                     = ["Metrics", "Logging", "AzureServices"]
  ip_rules                   = [data.http.machine_ip.response_body]
  virtual_network_subnet_ids = null # [azurerm_subnet.subnet_mgt.0.id]
}

resource "azurerm_storage_account" "storage" {
  count                         = var.enable_storage_account ? 1 : 0
  name                          = var.storage_account_name
  resource_group_name           = azurerm_resource_group.rg_spoke_aks.name
  location                      = var.resources_location
  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
  tags                          = var.tags
}

resource "azurerm_storage_container" "container" {
  count                 = var.enable_storage_account ? 1 : 0
  name                  = "my-files"
  storage_account_name  = azurerm_storage_account.storage.0.name
  container_access_type = "container" # "blob private"
}

resource "azurerm_storage_blob" "blob" {
  count                  = var.enable_storage_account ? 1 : 0
  name                   = "vm-install-cli-tools.sh"
  storage_account_name   = azurerm_storage_account.storage.0.name
  storage_container_name = azurerm_storage_container.container.0.name
  type                   = "Block"
  source                 = "storage_account.tf" # "vm-install-cli-tools.sh"
}