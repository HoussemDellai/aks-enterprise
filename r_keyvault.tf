resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name
  location                    = var.resources_location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enabled_for_disk_encryption = false
  sku_name                    = "standard"
  enable_rbac_authorization   = true
  tags                        = var.tags
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "database-password"
  value        = "@Aa123456789"
  key_vault_id = azurerm_key_vault.kv.id
  tags         = var.tags
  depends_on   = [azurerm_role_assignment.role-secret-officer]
}

resource "azurerm_role_assignment" "role-secret-officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Secret Store CSI Driver (generated with addon) Identity 
resource "azurerm_role_assignment" "role-secret-user" {
  scope                = "${azurerm_key_vault.kv.id}/secrets/${azurerm_key_vault_secret.secret.name}" # azurerm_key_vault_secret.secret.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider.0.secret_identity.0.object_id
}