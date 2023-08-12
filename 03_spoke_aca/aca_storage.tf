# resource "azurerm_storage_account" "example" {
#   name                     = "storage1aca13579"
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_share" "example" {
#   name                 = "sharename"
#   storage_account_name = azurerm_storage_account.example.name
#   quota                = 5
# }

# resource "azurerm_container_app_environment_storage" "example" {
#   name                         = "mycontainerappstorage"
#   container_app_environment_id = azurerm_container_app_environment.example.id
#   account_name                 = azurerm_storage_account.example.name
#   share_name                   = azurerm_storage_share.example.name
#   access_key                   = azurerm_storage_account.example.primary_access_key
#   access_mode                  = "ReadOnly"
# }