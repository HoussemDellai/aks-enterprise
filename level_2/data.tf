data terraform_remote_state level_1 {
  backend = "local" # "remote"

  config = {
    path = "../level_1/terraform.tfstate"
  }
}

data azurerm_resources vnet {
  type          = "Microsoft.Network/virtualNetworks"
  required_tags = var.tags
}

# get more info about VNETs that with azurerm_resources
data azurerm_virtual_network vnet {
  count               = length(data.azurerm_resources.vnet.resources)
  name                = data.azurerm_resources.vnet.resources[count.index].name
  resource_group_name = split("/", data.azurerm_resources.vnet.resources[count.index].id)[4]
}

data azurerm_subnet subnet {
  count                = length(local.subnets)
  name                 = local.subnets[count.index].subnet_name
  virtual_network_name = local.subnets[count.index].subnet_vnet
  resource_group_name  = local.subnets[count.index].subnet_rg
}

locals {
  # resource_ids = flatten([ for r in data.azurerm_resources.resources_ds : [ r.resources.*.id ] ])
  subnets = flatten([for vnet in data.azurerm_virtual_network.vnet : [
    for snet in vnet.subnets : {
      subnet_name = snet,
      subnet_vnet = vnet.name,
      subnet_rg   = vnet.resource_group_name
      subnet_id   = "${vnet.id}/subnets/${snet}"
    }]
  ])
}

data azurerm_resources public_ip {
  type          = "Microsoft.Network/publicIPAddresses"
  required_tags = var.tags
}
