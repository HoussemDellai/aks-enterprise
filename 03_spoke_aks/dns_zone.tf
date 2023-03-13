resource "azurerm_dns_a_record" "dns_record_appgw" {
  #   provider            = azurerm.subscription_hub
  name                = "appgw"
  zone_name           = data.terraform_remote_state.hub.0.outputs.dns_zone.name
  resource_group_name = data.terraform_remote_state.hub.0.outputs.dns_zone.resource_group_name
  ttl                 = 300
  records             = [azurerm_public_ip.appgw_pip.0.ip_address]
}