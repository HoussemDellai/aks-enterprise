data "azurerm_dns_zone" "dns_zone" {
  name                = "houssem.cloud"
  resource_group_name = "rg-dns-zone-houssem-cloud"
}

resource "azurerm_dns_zone" "dns_zone_apps" {
  name                = "apps.${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = data.azurerm_dns_zone.dns_zone.resource_group_name
}

resource "azurerm_dns_a_record" "example" {
  name                = "test"
  zone_name           = azurerm_dns_zone.dns_zone_apps.name
  resource_group_name = azurerm_dns_zone.dns_zone_apps.resource_group_name
  ttl                 = 300
  records             = ["10.0.180.17"]
}