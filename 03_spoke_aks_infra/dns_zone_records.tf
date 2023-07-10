resource "azurerm_dns_a_record" "dns_record_appgw" {
  #   provider            = azurerm.subscription_hub
  count               = var.enable_app_gateway ? 1 : 0
  name                = "appgw"
  zone_name           = data.terraform_remote_state.hub.0.outputs.dns_zone.name
  resource_group_name = data.terraform_remote_state.hub.0.outputs.dns_zone.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.appgw_pip.0.ip_address]
}

resource "azurerm_dns_cname_record" "cname_record_grafana" {
  #   provider            = azurerm.subscription_hub
  count               = var.enable_grafana_prometheus ? 1 : 0
  name                = "grafana"
  zone_name           = data.terraform_remote_state.hub.0.outputs.dns_zone.name
  resource_group_name = data.terraform_remote_state.hub.0.outputs.dns_zone.resource_group_name
  ttl                 = 300
  record              = replace(azurerm_dashboard_grafana.grafana_aks.0.endpoint, "https://"  , "")
}