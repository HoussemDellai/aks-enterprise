data "azurerm_resources" "vnet" {
  #   count = var.enable_firewall ? 1 : 0
  type          = "Microsoft.Network/virtualNetworks"
  required_tags = var.tags
}

locals {
  vnet = tomap({ for vnet in data.azurerm_resources.vnet.resources : vnet.name => {
    id                  = vnet.id,
    name                = vnet.name,
    location            = vnet.location,
    resource_group_name = split("/", vnet.id)[4]
    }
  })
}

data "azurerm_virtual_network" "vnet" {
  for_each            = local.vnet
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

locals {
  subnets = flatten([
    for vnet in data.azurerm_virtual_network.vnet : [
      for subnet in vnet.subnets : {
        subnet_name = subnet,
        vnet_name   = vnet.name,
        subnet_id   = "${vnet.id}/subnets/${subnet}"
      }
    ]
  ])

  subnets_map = tomap({ for subnet in local.subnets :
    subnet.subnet_name => subnet
    if subnet.subnet_name != "AzureFirewallSubnet"
    && subnet.subnet_name != "AzureBastionSubnet"
    && subnet.subnet_name != "GatewaySubnet"
    && subnet.subnet_name != "subnet-appgw"
  })
}



# create an NSG for each VNET
resource "azurerm_network_security_group" "nsg" {
  for_each            = local.vnet
  location            = each.value.location
  name                = "nsg-${each.value.name}"
  resource_group_name = each.value.resource_group_name # split("/", each.value.id)[4]
  tags                = var.tags
}

resource "azurerm_network_security_rule" "rule_shared" {
  for_each                    = azurerm_network_security_group.nsg
  name                        = "rule-shared"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = each.value.resource_group_name
  network_security_group_name = each.value.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each                  = local.subnets_map
  subnet_id                 = each.value.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.vnet_name].id
}