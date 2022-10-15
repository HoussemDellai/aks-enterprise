# resource "azurerm_storage_account" "storage" {
#   name                     = "storage01998" #TODO var.storage_account
#   resource_group_name      = azurerm_resource_group.rg_spoke.name
#   location                 = var.resources_location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   network_rules {
#     default_action             = "Deny"
#     ip_rules                   = ["100.0.0.1"]
#     virtual_network_subnet_ids = [azurerm_subnet.subnet_mgt.id]
#   }
# }

# resource "azurerm_storage_container" "container" {
#   name                  = "my-files"
#   storage_account_name  = azurerm_storage_account.storage.name
#   container_access_type = "container" # "blob" "private"
# }

# resource "azurerm_storage_blob" "blob" {
#   name                   = "aks.tf"
#   storage_account_name   = azurerm_storage_account.storage.name
#   storage_container_name = azurerm_storage_container.container.name
#   type                   = "Block"
#   source                 = "aks.tf"
# }