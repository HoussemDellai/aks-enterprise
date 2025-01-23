# # locals {
# #   cidr_subnet_aks_nodes_pods = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.address_space
# # }
# # locals {
# #   cidr_subnet_aks_nodes_pods = concat(
# #     azurerm_subnet.subnet_nodes.address_prefixes, 
# #     azurerm_subnet.subnet_pods.address_prefixes,
# #     # [for snet in azurerm_subnet.subnet_nodes_user_nodepool : snet.address_prefixes],
# #     # azurerm_subnet.subnet_nodes_user_nodepool.0.address_prefixes,
# #     # azurerm_subnet.subnet_pods_user_nodepool.0.address_prefixes
# #     )
# # }

# resource "azurerm_firewall_policy_rule_collection_group" "policy_group_aks" {
#   count              = var.enable_route_traffic_to_firewall ? 1 : 0
#   name               = "policy_group_aks"
#   firewall_policy_id = data.terraform_remote_state.hub.0.outputs.firewall.policy_id # azurerm_firewall_policy.firewall_policy.id
#   priority           = 200

#   application_rule_collection {
#     name     = "open-all"
#     priority = 100
#     action   = "Allow"

#     rule {
#       name = "open-all"
#       protocols {
#         type = "Http"
#         port = 80
#       }
#       protocols {
#         type = "Https"
#         port = 443
#       }
#       source_addresses  = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_fqdns = ["*"]
#     }
#   }

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
#       source_addresses      = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_fqdn_tags = ["AzureKubnernetesService"]
#     }
#   }

#   application_rule_collection {
#     name     = "allow_debian_updates"
#     priority = 210
#     action   = "Allow"

#     rule {
#       name = "allow_deb_debian_org"
#       protocols {
#         type = "Http"
#         port = 80
#       }
#       #   protocols {
#       #     type = "Https"
#       #     port = 443
#       #   }
#       source_addresses  = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_fqdns = ["deb.debian.org"]
#     }
#   }

#   network_rule_collection {
#     name     = "aks_network_rules"
#     priority = 201
#     action   = "Allow"
#     rule {
#       name                  = "https"
#       protocols             = ["TCP"]
#       source_addresses      = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_addresses = ["*"]
#       destination_ports     = ["443"]
#     }
#     rule {
#       name                  = "dns"
#       protocols             = ["UDP"]
#       source_addresses      = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_addresses = ["*"]
#       destination_ports     = ["53"]
#     }
#     rule {
#       name                  = "time"
#       protocols             = ["UDP"]
#       source_addresses      = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_addresses = ["*"]
#       destination_ports     = ["123"]
#     }
#     rule {
#       name                  = "tunnel_udp"
#       protocols             = ["UDP"]
#       source_addresses      = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_addresses = ["*"]
#       destination_ports     = ["1194"]
#     }
#     rule {
#       name                  = "tunnel_tcp"
#       protocols             = ["TCP"]
#       source_addresses      = azurerm_virtual_network.vnet_spoke_aks.address_space
#       destination_addresses = ["*"]
#       destination_ports     = ["9000"]
#     }
#     rule {
#       name                  = "Time"
#       source_addresses      = ["*"]
#       destination_ports     = ["123"]
#       destination_addresses = ["*"]
#       protocols             = ["UDP"]
#     }
#     rule {
#       name                  = "DNS"
#       source_addresses      = ["*"]
#       destination_ports     = ["53"]
#       destination_addresses = ["*"]
#       protocols             = ["UDP"]
#     }
#     rule {
#       name              = "ServiceTags"
#       source_addresses  = ["*"]
#       destination_ports = ["*"]
#       destination_addresses = [
#         "AzureContainerRegistry",
#         "MicrosoftContainerRegistry",
#         "AzureActiveDirectory"
#       ]
#       protocols = ["Any"]
#     }
#     # rule {
#     #   name                  = "Internet"
#     #   source_addresses      = ["*"]
#     #   destination_ports     = ["*"]
#     #   destination_addresses = ["*"]
#     #   protocols             = ["TCP"]
#     # }
#   }

#   # network_rule_collection {
#   #   name     = "allow_pods_to_subnet_mgt"
#   #   priority = 202
#   #   action   = "Allow"
#   #   rule {
#   #     name                  = "http"
#   #     protocols             = ["TCP"]
#   #     source_addresses      = azurerm_subnet.subnet_pods.address_prefixes # ["10.3.1.0/24"]
#   #     destination_addresses = azurerm_subnet.subnet_mgt.address_prefixes
#   #     destination_ports     = ["80"]
#   #   }
#   # }
# }
