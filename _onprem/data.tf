data "azurerm_client_config" "current" {}

data "azurerm_subscription" "subscription_onprem" {
  subscription_id = var.subscription_id_onprem
}