resource "azurerm_key_vault" "kv" {
  count                         = var.enable_keyvault ? 1 : 0
  name                          = var.keyvault_name
  location                      = var.resources_location
  resource_group_name           = azurerm_resource_group.rg_spoke_app.name
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
    ip_rules                   = [data.http.machine_ip.response_body]
    virtual_network_subnet_ids = null
  }
}

resource "azurerm_key_vault_secret" "secret" {
  count        = var.enable_keyvault ? 1 : 0
  name         = "database-password"
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

module "diagnostic_setting_keyvault" {
  count                      = var.enable_monitoring && var.enable_keyvault ? 1 : 0
  source                     = "./modules/diagnostic_setting"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id
  target_resource_id         = azurerm_key_vault.kv.0.id
}

output "monitor_diagnostic_categories_keyvault" {
  value = module.diagnostic_setting_keyvault.0.monitor_diagnostic_categories
}

# # https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/key_vault.tf
# resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_keyvault" {
#   count                          = var.enable_monitoring && var.enable_keyvault ? 1 : 0
#   name                           = "diagnostic-settings"
#   target_resource_id             = azurerm_key_vault.kv.0.id
#   log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.0.id
#   log_analytics_destination_type = "AzureDiagnostics" # "Dedicated"

#   enabled_log {
#     category = "AuditEvent"

#     retention_policy {
#       enabled = true
#     }
#   }

#   enabled_log {
#     category = "AzurePolicyEvaluationDetails"

#     retention_policy {
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }
# }
