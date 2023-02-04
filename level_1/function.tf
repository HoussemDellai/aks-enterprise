resource "azurerm_resource_group" "rg_spoke_serverless" {
  count    = var.enable_spoke_serverless ? 1 : 0
  name     = "rg-spoke-serverless"
  location = var.resources_location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage_function" {
  count                    = var.enable_spoke_serverless ? 1 : 0
  name                     = "storage4function0135"
  resource_group_name      = azurerm_resource_group.rg_spoke_serverless.0.name
  location                 = azurerm_resource_group.rg_spoke_serverless.0.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_service_plan" "plan_function" {
  count               = var.enable_spoke_serverless ? 1 : 0
  name                = "function-app-service-plan"
  resource_group_name = azurerm_resource_group.rg_spoke_serverless.0.name
  location            = azurerm_resource_group.rg_spoke_serverless.0.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags                = var.tags
}

resource "azurerm_windows_function_app" "function_app" {
  count               = var.enable_spoke_serverless ? 1 : 0
  name                = "function-app-win-0135"
  resource_group_name = azurerm_resource_group.rg_spoke_serverless.0.name
  location            = azurerm_resource_group.rg_spoke_serverless.0.location
  tags                = var.tags

  storage_account_name       = azurerm_storage_account.storage_function.0.name
  storage_account_access_key = azurerm_storage_account.storage_function.0.primary_access_key
  service_plan_id            = azurerm_service_plan.plan_function.0.id

  site_config {}
}