locals {
  cidr_subnet_aks_nodes_pods = concat(azurerm_subnet.subnet_nodes.address_prefixes, azurerm_subnet.subnet_pods.address_prefixes)
}

resource "azurerm_firewall_policy" "policy_aks" {
  count               = var.enable_firewall ? 1 : 0
  name                = "policy_aks"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.resources_location
}

resource "azurerm_firewall_policy_rule_collection_group" "policy_group_aks" {
  count              = var.enable_firewall ? 1 : 0
  name               = "policy_group_aks"
  firewall_policy_id = azurerm_firewall_policy.policy_aks.0.id
  priority           = 200

  application_rule_collection {
    name     = "aks_app_rules"
    priority = 205
    action   = "Allow"
    rule {
      name = "aks_service"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = local.cidr_subnet_aks_nodes_pods
      destination_fqdn_tags = ["AzureKubnernetesService"]
    }
  }

  network_rule_collection {
    name     = "aks_network_rules"
    priority = 201
    action   = "Allow"
    rule {
      name                  = "https"
      protocols             = ["TCP"]
      source_addresses      = local.cidr_subnet_aks_nodes_pods
      destination_addresses = ["*"]
      destination_ports     = ["443"]
    }
    rule {
      name                  = "dns"
      protocols             = ["UDP"]
      source_addresses      = local.cidr_subnet_aks_nodes_pods
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }
    rule {
      name                  = "time"
      protocols             = ["UDP"]
      source_addresses      = local.cidr_subnet_aks_nodes_pods
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
    rule {
      name                  = "tunnel_udp"
      protocols             = ["UDP"]
      source_addresses      = local.cidr_subnet_aks_nodes_pods
      destination_addresses = ["*"]
      destination_ports     = ["1194"]
    }
    rule {
      name                  = "tunnel_tcp"
      protocols             = ["TCP"]
      source_addresses      = local.cidr_subnet_aks_nodes_pods
      destination_addresses = ["*"]
      destination_ports     = ["9000"]
    }
  }
}