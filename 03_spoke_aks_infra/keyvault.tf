resource "azurerm_key_vault" "kv" {
  count                         = var.enable_keyvault ? 1 : 0
  name                          = var.keyvault_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  enabled_for_disk_encryption   = false
  public_network_access_enabled = true
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  tags                          = var.tags

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = [local.machine_ip]
    virtual_network_subnet_ids = null
  }
}

resource "azurerm_key_vault_secret" "secret" {
  count        = var.enable_keyvault ? 1 : 0
  name         = "db-password"
  value        = "@Aa123456789"
  key_vault_id = azurerm_key_vault.kv.0.id
  tags         = var.tags
  depends_on   = [azurerm_role_assignment.role_secret_officer]
}

resource "azurerm_role_assignment" "role_secret_officer" {
  count                = var.enable_keyvault ? 1 : 0
  scope                = azurerm_key_vault.kv.0.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}