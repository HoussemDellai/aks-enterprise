output "vnet_hub" {
  value = {
    id = azurerm_virtual_network.vnet_hub.id
  }
}

output "firewall" {
  value = {
    enabled    = var.enable_firewall
    private_ip = var.enable_firewall ? azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address : null
    policy_id  = var.enable_firewall ? azurerm_firewall_policy.firewall_policy.0.id : null
  }
}

# output "route_table_id" {
#   value = azurerm_route_table.route_table_to_firewall.id
# }