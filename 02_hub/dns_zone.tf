data "azurerm_dns_zone" "dns_zone" {
  provider            = azurerm.subscription_hub
  name                = "houssem.cloud"
  resource_group_name = "rg-azure-dns"
}

resource "azurerm_dns_zone" "dns_zone_apps" {
  provider            = azurerm.subscription_hub
  name                = "aks-apps.${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = azurerm_resource_group.rg_hub.name # data.azurerm_dns_zone.dns_zone.resource_group_name
}

resource "azurerm_dns_a_record" "example" {
  provider            = azurerm.subscription_hub
  name                = "test"
  zone_name           = azurerm_dns_zone.dns_zone_apps.name
  resource_group_name = azurerm_dns_zone.dns_zone_apps.resource_group_name
  ttl                 = 300
  records             = ["10.0.180.17"]
}
