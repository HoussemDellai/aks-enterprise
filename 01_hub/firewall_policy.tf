resource "azurerm_firewall_policy" "firewall_policy" {
  provider            = azurerm.subscription_hub
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = var.firewall_sku_tier # "Basic" # "Standard" # "Premium" #

  dynamic "dns" {
    for_each = var.enable_firewall && var.firewall_sku_tier != "Basic" ? ["any_value"] : []
    content {
      proxy_enabled = true
      servers       = ["168.63.129.16"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "policy_group" {
  provider           = azurerm.subscription_hub
  name               = "policy-group"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
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

  # allow raw.githubusercontent.com, to get the custom scripts to install to VMs
  application_rule_collection {
    name     = "app_rules_allow_githubusercontent_any_source"
    priority = 101
    action   = "Allow"

    rule {
      name = "allow_githubusercontent_com"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"] # local.cidr_subnet_aks_nodes_pods # azurerm_subnet.subnet_mgt.address_prefixes
      destination_fqdns = ["raw.githubusercontent.com"]
    }
  }
}
