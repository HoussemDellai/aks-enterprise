# https://learn.microsoft.com/en-us/azure/aks/limit-egress-traffic?tabs=aks-with-system-assigned-identities
# https://learn.microsoft.com/en-us/azure/firewall/integrate-lb

resource "azurerm_route" "route_to_internet" {
  name                = "route-to-internet"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.route_table.name
  address_prefix      = "${data.terraform_remote_state.hub.outputs.firewall.public_ip}/32" # "10.0.0.0/8" # "0.0.0.0/0"
  next_hop_type       = "Internet"                                                         # "VirtualNetworkGateway"
}

resource "azurerm_firewall_policy_rule_collection_group" "policy_group_dnat_aks" {
  name               = "policy-group-dnat-aks"
  firewall_policy_id = data.terraform_remote_state.hub.outputs.firewall.policy_id
  priority           = 300

  nat_rule_collection {
    name     = "dnat-inbound-rule-aks"
    priority = 300
    action   = "Dnat"

    rule {
      name                = "dnat-inbound-rule-aks"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = data.terraform_remote_state.hub.outputs.firewall.public_ip
      destination_ports   = ["80"]
      translated_address  = "74.241.208.23"
      translated_port     = "80"
    }
  }
}

# resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {
#   name                = "dnat-inbound-rule-collection"
#   azure_firewall_name = data.terraform_remote_state.hub.outputs.firewall.name
#   resource_group_name = data.terraform_remote_state.hub.outputs.firewall.rg_name
#   priority            = 100
#   action              = "Dnat"

#   rule {
#     name                  = "dnat-inbound-rule-aks"
#     source_addresses      = ["*"]
#     destination_addresses = [data.terraform_remote_state.hub.outputs.firewall.public_ip]
#     destination_ports     = ["80"]
#     translated_address    = "9.223.227.105" # replace with exposed service's Load Balancer IP
#     translated_port       = 80
#     protocols             = ["TCP", "UDP"]
#   }
# }
