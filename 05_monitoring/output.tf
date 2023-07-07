output "diagnostic_settings" {
  value = [for r in local.resource_ids : "${format("%s / %s / %s", split("/", r)[7], split("/", r)[4], split("/", r)[8])}"]
}

# output "nsg" {
#   value = toset({ for nsg in azurerm_network_security_group.nsg : {nsg.name } })
# }

output "flow_log" {
  value = [for r in local.nsg : "${format("%s / %s / %s", split("/", r.id)[7], split("/", r.id)[4], split("/", r.id)[8])}"]
  # value = [for r in local.nsg : r.id]
  # value = local.nsg
}