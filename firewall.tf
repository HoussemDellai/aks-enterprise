resource "azurerm_public_ip" "public_ip_firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub # .ms-internal
  name                = "public-ip-firewall"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub # .ms-internal
  name                = "firewall-hub"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name
  sku_name            = "AZFW_VNet" # AZFW_Hub
  sku_tier            = "Standard"  # Premium 
  dns_servers         = ["168.63.129.16"]
  # firewall_policy_id  

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_firewall.0.id
    public_ip_address_id = azurerm_public_ip.public_ip_firewall.0.id
  }
}

# Azure Firewall Application Rule
# resource "azurerm_firewall_application_rule_collection" "azufwappr1" {
#   name                = "appRc1"
#   azure_firewall_name = azurerm_firewall.azufw.name
#   resource_group_name = azurerm_resource_group.azurg.name
#   priority            = 101
#   action              = "Allow"

#   rule {
#     name = "appRule1"

#     source_addresses = [
#       "10.0.0.0/24",
#     ]

#     target_fqdns = [
#       "www.microsoft.com",
#     ]

#     protocol {
#       port = "80"
#       type = "Http"
#     }
#   }
# }

# # Azure Firewall Network Rule
# resource "azurerm_firewall_network_rule_collection" "azufwnetr1" {
#   name                = "testcollection"
#   azure_firewall_name = azurerm_firewall.azufw.name
#   resource_group_name = azurerm_resource_group.azurg.name
#   priority            = 200
#   action              = "Allow"

#   rule {
#     name = "netRc1"

#     source_addresses = [
#       "10.0.0.0/24",
#     ]

#     destination_ports = [
#       "8000-8999",
#     ]

#     destination_addresses = [
#       "*",
#     ]

#     protocols = [
#       "TCP",
#     ]
#   }
# }

# resource "azurerm_firewall_policy" "aks" {
#   name                = "AKSpolicy"
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

# output "fw_policy_id" {
#     value = azurerm_firewall_policy.aks.id
# }

# # Rules Collection Group

# resource "azurerm_firewall_policy_rule_collection_group" "AKS" {
#   name               = "aks-rcg"
#   firewall_policy_id = azurerm_firewall_policy.aks.id
#   priority           = 200
#   application_rule_collection {
#     name     = "aks_app_rules"
#     priority = 205
#     action   = "Allow"
#     rule {
#       name = "aks_service"
#       protocols {
#         type = "Https"
#         port = 443
#       }
#       source_addresses      = ["10.1.0.0/16"]
#       destination_fqdn_tags = ["AzureKubnernetesService"]
#     }
#   }

#   network_rule_collection {
#     name     = "aks_network_rules"
#     priority = 201
#     action   = "Allow"
#     rule {
#       name                  = "https"
#       protocols             = ["TCP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["443"]
#     }
#     rule {
#       name                  = "dns"
#       protocols             = ["UDP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["53"]
#     }
#     rule {
#       name                  = "time"
#       protocols             = ["UDP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["123"]
#     }
#     rule {
#       name                  = "tunnel_udp"
#       protocols             = ["UDP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["1194"]
#     }
#     rule {
#       name                  = "tunnel_tcp"
#       protocols             = ["TCP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["9000"]
#     }
#   }
# }

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings_firewall" {
  provider                   = azurerm.subscription_hub
  count                      = var.enable_firewall && var.enable_monitoring ? 1 : 0
  name                       = "diagnostic-settings"
  target_resource_id         = azurerm_firewall.firewall.0.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.0.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
  # other logs to include #TODO
  # AZFWNetworkRule, AZFWNatRuleAggregation, AZFWNetworkRuleAggregation, 
  # AZFWApplicationRuleAggregation, AZFWFatFlow, AZFWFqdnResolveFailure, 
  # AZFWDnsQuery, AZFWIdpsSignature, AZFWThreatIntel, 
  # AZFWApplicationRule, AZFWNatRule

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
}