output "vnet_spoke_aks" {
  value = {
    virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
    resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
    id                   = azurerm_virtual_network.vnet_spoke_aks.id
    address_space        = azurerm_virtual_network.vnet_spoke_aks.address_space
  }
}

output "snet_aks" {
  value = {
    id = azurerm_subnet.snet_aks.id
  }
}

output "acr" {
  value = {
    id = azurerm_container_registry.acr.id
  }
}

output "application_gateway" {
  value = {
    enabled = var.enable_app_gateway
    id      = var.enable_app_gateway ? azurerm_application_gateway.appgw.0.id : null
  }
}

output "grafana" {
  value = {
    id       = azurerm_dashboard_grafana.grafana.0.id
    endpoint = azurerm_dashboard_grafana.grafana.0.endpoint
    dns_url  = try(azurerm_dns_cname_record.cname_record_grafana.0.record, null)
  }
}

output "prometheus" {
  value = {
    id                          = azurerm_monitor_workspace.prometheus.0.id
    data_collection_rule_id     = azurerm_monitor_data_collection_rule.data_collection_rule.0.id
    data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.data_collection_endpoint.0.id
  }
}

output "dns_zone_apps" {
  value = {
    fqdn = var.enable_hub_spoke && var.enable_app_gateway ? azurerm_dns_a_record.dns_record_appgw.0.fqdn : null
  }
}

output "route_table" {
  value = {
    id = azurerm_route_table.route_table_to_firewall.id
  }
}
