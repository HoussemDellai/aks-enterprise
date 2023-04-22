output "diagnostic_settings" {
  value = local.resource_ids
}

# output "nsg" {
#   value = toset({ for nsg in azurerm_network_security_group.nsg : {nsg.name } })
# }

output "flow_log" {
  value = local.nsg
}