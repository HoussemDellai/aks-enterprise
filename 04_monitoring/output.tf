output "diagnostic_settings" {
  value = local.resource_ids
}

output "nsg" {
  value = azurerm_network_security_group.nsg
}

output "flow_log" {
  value = local.nsg
}