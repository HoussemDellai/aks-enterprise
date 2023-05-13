# locals {
#   cidr_subnet_aks_nodes_pods = concat(azurerm_subnet.subnet_nodes.address_prefixes, azurerm_subnet.subnet_pods.address_prefixes)
# }

resource "azurerm_firewall_policy_rule_collection_group" "policy_group_subnet_mgt" {
  count              = var.enable_firewall ? 1 : 0
  name               = "policy_group_subnet_vm"
  firewall_policy_id = data.terraform_remote_state.hub.0.outputs.firewall.policy_id # azurerm_firewall_policy.firewall_policy.id
  priority           = 300

  application_rule_collection {
    name     = "app_rules_subnet_vm"
    priority = 305
    action   = "Allow"
    # rule {
    #   name = "allow_subnet_mgt_to_subnet_pe"
    #   protocols {
    #     type = "Http"
    #     port = 80
    #   }
    #   protocols {
    #     type = "Https"
    #     port = 443
    #   }
    #   source_addresses  = azurerm_subnet.subnet_mgt.address_prefixes
    #   destination_fqdns = [
    #     azurerm_private_dns_zone.private_dns_zone_storage.name,
    #     azurerm_private_dns_zone.private_dns_zone_acr.name
    #     # azurerm_private_dns_zone.aks.name
    #   ]
    # }
    # rule {
    #   name = "allow_microsoft_com"
    #   protocols {
    #     type = "Http"
    #     port = 80
    #   }
    #   protocols {
    #     type = "Https"
    #     port = 443
    #   }
    #   source_addresses  = azurerm_subnet.subnet_mgt.address_prefixes
    #   destination_fqdns = ["*.microsoft.com"]
    # }
    rule {
      name = "allow_internet"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_subnet.subnet_vm.address_prefixes
      destination_fqdns = ["*"]
    }
  }

  # network_rule_collection {
  #   name     = "allow_subnet_mgt_to_subnet_pe"
  #   priority = 201
  #   action   = "Allow"
  #   rule {
  #     name                  = "https"
  #     protocols             = ["TCP"]
  #     source_addresses      = azurerm_subnet.subnet_mgt.address_prefixes
  #     destination_addresses = azurerm_subnet.subnet_spoke_aks_pe.address_prefixes
  #     destination_ports     = ["443"]
  #   }
  # }
}