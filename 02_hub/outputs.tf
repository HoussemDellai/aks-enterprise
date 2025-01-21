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

output "dns_zone_apps" {
  value = {
    name                = azurerm_dns_zone.dns_zone_apps.name
    resource_group_name = azurerm_dns_zone.dns_zone_apps.resource_group_name
  }
}

output "dns_zone_aks" {
  value = {
    id = azurerm_private_dns_zone.private_dns_zone_aks.id
  }
}