output "vnet_hub_id" {
  value = azurerm_virtual_network.vnet_hub.id
}

output "firewall_private_ip" {
  value = azurerm_firewall.firewall.ip_configuration.0.private_ip_address
}

output "firewall_policy_id" {
  value = azurerm_firewall_policy.firewall_policy.id
}