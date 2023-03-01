# resource azurerm_subnet_route_table_association association_route_table_subnet {
#   count          = length(data.azurerm_subnet.subnet)
#   subnet_id      = data.azurerm_subnet.subnet[count.index].id
#   route_table_id = data.terraform_remote_state.level_1.outputs.route_table_to_firewall_id
# }

locals {
    snets = { 
      for snet in local.subnets : 
        snet.subnet_name => snet 
          if snet.subnet_name != "AzureFirewallSubnet" 
             && snet.subnet_name != "AzureBastionSubnet" 
             && snet.subnet_name != "GatewaySubnet"
    }
  # snets = { for snet in local.subnets : snet.subnet_name => snet }
}

output snets {
  value = local.snets
}

resource azurerm_network_security_group nsg_subnet {
  for_each            = local.snets
  name                = "nsg_${local.snets[each.key].subnet_name}"
  location            = var.resources_location
  resource_group_name = local.snets[each.key].subnet_rg
  tags                = var.tags
}

# resource azurerm_network_security_group nsg_subnet {
#   count               = length(local.subnets)
#   name                = "nsg_${local.subnets[count.index].subnet_name}"
#   location            = var.resources_location
#   resource_group_name = local.subnets[count.index].subnet_rg
#   tags                = var.tags
# }

resource azurerm_subnet_network_security_group_association association_nsg_subnet {
  for_each                  = local.snets
  subnet_id                 = local.snets[each.key].subnet_id
  network_security_group_id = azurerm_network_security_group.nsg_subnet[each.key].id
}

# resource azurerm_subnet_network_security_group_association association_nsg_subnet {
#   count                     = length(local.subnets)
#   subnet_id                 = data.azurerm_subnet.subnet[count.index].id
#   network_security_group_id = azurerm_network_security_group.nsg_subnet[count.index].id
# }
