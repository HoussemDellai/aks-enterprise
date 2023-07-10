# import my existing custom domain name (houssem.cloud)
data "azurerm_dns_zone" "dns_zone_parent" {
  provider            = azurerm.subscription_hub
  name                = "houssemd.com"
  resource_group_name = "rg-dns"
}

# create sub-dns zone
resource "azurerm_dns_zone" "dns_zone_apps" {
  provider            = azurerm.subscription_hub
  name                = "aks-apps.${data.azurerm_dns_zone.dns_zone_parent.name}"
  resource_group_name = azurerm_resource_group.rg_hub.name # data.azurerm_dns_zone.dns_zone.resource_group_name
}

# create ns record for sub-zone in parent zone
# trick: https://github.com/hashicorp/terraform-provider-azurerm/issues/14733
resource "azurerm_dns_ns_record" "dns_ns_record" {
  provider            = azurerm.subscription_hub
  name                = "aks-apps" # only the flat name not the fqdn
  zone_name           = data.azurerm_dns_zone.dns_zone_parent.name
  resource_group_name = data.azurerm_dns_zone.dns_zone_parent.resource_group_name
  ttl                 = 3600
  records             = azurerm_dns_zone.dns_zone_apps.name_servers
}

resource "azurerm_dns_a_record" "a_record_test" {
  provider            = azurerm.subscription_hub
  name                = "test"
  zone_name           = azurerm_dns_zone.dns_zone_apps.name
  resource_group_name = azurerm_dns_zone.dns_zone_apps.resource_group_name
  ttl                 = 300
  records             = ["100.101.102.103"]
}
