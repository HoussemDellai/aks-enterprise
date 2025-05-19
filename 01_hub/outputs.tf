output "vnet_hub" {
  value = {
    id = azurerm_virtual_network.vnet_hub.id
  }
}

output "firewall" {
  value = {
    enabled    = var.enable_firewall
    private_ip = var.enable_firewall ? azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address : null
    public_ip  = var.enable_firewall ? azurerm_public_ip.public_ip_firewall.0.ip_address : null
    policy_id  = var.enable_firewall ? azurerm_firewall_policy.firewall_policy.id : null
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

output "log_analytics_workspace" {
  value = {
    id           = azurerm_log_analytics_workspace.workspace.id
    location     = azurerm_log_analytics_workspace.workspace.location
    workspace_id = azurerm_log_analytics_workspace.workspace.workspace_id
  }
}
