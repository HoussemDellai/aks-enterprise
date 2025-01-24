resource "azuread_group" "aks_admins" {
  display_name     = "aks-admins"
  security_enabled = true
  owners           = [data.azurerm_client_config.current.object_id]

  members = [
    data.azurerm_client_config.current.object_id
  ]
}

data "azurerm_client_config" "current" {}
