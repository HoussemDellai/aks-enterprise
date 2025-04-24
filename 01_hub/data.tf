data "azurerm_subscription" "subscription_hub" {
  provider        = azurerm.subscription_hub
  subscription_id = var.subscription_id_hub
}