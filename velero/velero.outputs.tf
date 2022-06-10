output "storage_account_name" {
  description = "The name of the created backup storage account"
  value       = azurerm_storage_account.storaccbackup.name
}

output "storage_container_name" {
  description = "The name of the created backup storage container"
  value       = azurerm_storage_container.storcontbackup.name
}