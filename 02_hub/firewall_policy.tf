# locals {
#   cidr_subnet_aks_nodes_pods = concat(azurerm_subnet.subnet_nodes.address_prefixes, azurerm_subnet.subnet_pods.address_prefixes)
# }

resource "azurerm_firewall_policy" "firewall_policy" {
  provider            = azurerm.subscription_hub
  count               = var.enable_firewall ? 1 : 0
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  sku                 = var.firewall_sku_tier # "Basic" # "Standard" # "Premium" #

  dynamic "dns" {
    for_each = var.enable_firewall && var.firewall_sku_tier != "Basic" ? ["any_value"] : []
    content {
      proxy_enabled = true
      servers       = ["168.63.129.16"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "policy_group_deny" {
  provider           = azurerm.subscription_hub
  count              = var.enable_firewall ? 1 : 0
  name               = "policy_group_deny"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.0.id
  priority           = 100

  application_rule_collection {
    name     = "app_rules_deny_yahoo_com_any_source"
    priority = 100
    action   = "Deny"

    rule {
      name = "deny_yahoo_com"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"] # local.cidr_subnet_aks_nodes_pods # azurerm_subnet.subnet_mgt.address_prefixes
      destination_fqdns = ["*.yahoo.com"]
    }
  }
}
