output "vnet_spoke_aks" {
  value = {
    virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
    resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
    id                   = azurerm_virtual_network.vnet_spoke_aks.id
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
    id      = azurerm_application_gateway.appgw.0.id
  }
}

output "grafana" {
  value = {
    id       = azurerm_dashboard_grafana.grafana_aks.0.id
    endpoint = azurerm_dashboard_grafana.grafana_aks.0.endpoint
  }
}

output "prometheus" {
  value = {
    id = azapi_resource.monitor_workspace_aks.0.id
  }
}

output "dns_zone_apps" {
  value = {
    fqdn = var.enable_hub_spoke ? azurerm_dns_a_record.dns_record_appgw.0.fqdn : null
  }
}
