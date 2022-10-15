resource "azurerm_public_ip" "public_ip_firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub
  name                = "public-ip-firewall"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub
  name                = "firewall-hub"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name
  sku_name            = "AZFW_VNet" # AZFW_Hub
  sku_tier            = "Standard"  # Premium 
  # dns_servers         = ["168.63.129.16"]
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.0.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_firewall.0.id
    public_ip_address_id = azurerm_public_ip.public_ip_firewall.0.id
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_firewall" {
  provider                       = azurerm.subscription_hub
  count                          = var.enable_firewall && var.enable_monitoring ? 1 : 0
  name                           = "diagnostic-settings"
  target_resource_id             = azurerm_firewall.firewall.0.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.0.id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category_group = "allLogs"
    enabled        = true

    retention_policy {
      enabled = true
    }
  }

  # log {
  #   category = "AzureFirewallApplicationRule"
  #   enabled  = true

  #   retention_policy {
  #     enabled = true
  #   }
  # }

  # log {
  #   category = "AzureFirewallNetworkRule"
  #   enabled  = true

  #   retention_policy {
  #     enabled = true
  #   }
  # }

  # log {
  #   category = "AzureFirewallDnsProxy"
  #   enabled  = true

  #   retention_policy {
  #     enabled = true
  #   }
  # }

  # dynamic "log" {
  #   for_each = toset(["AZFWNetworkRule", "AZFWNatRuleAggregation", "AZFWNetworkRuleAggregation",
  #                     "AZFWApplicationRuleAggregation", "AZFWFatFlow", "AZFWFqdnResolveFailure",
  #                     "AZFWDnsQuery", "AZFWIdpsSignature", "AZFWThreatIntel",
  #                     "AZFWApplicationRule", "AZFWNatRule"])
  #   content {
  #     category = log.key #each.key
  #     enabled  = true

  #     retention_policy {
  #       enabled = true
  #     }
  #   }
  # }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
}
