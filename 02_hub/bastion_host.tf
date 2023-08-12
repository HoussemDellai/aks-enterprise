resource "azurerm_subnet" "subnet_bastion" {
  provider             = azurerm.subscription_hub
  count                = var.enable_bastion ? 1 : 0
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  resource_group_name  = azurerm_virtual_network.vnet_hub.resource_group_name
  address_prefixes     = var.cidr_subnet_bastion
}

# https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/bastion_host.tf
resource "azurerm_public_ip" "public_ip_bastion" {
  provider            = azurerm.subscription_hub
  count               = var.enable_bastion ? 1 : 0
  name                = "public-ip-bastion"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name #var.rg_spoke
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_host" {
  provider               = azurerm.subscription_hub
  count                  = var.enable_bastion ? 1 : 0
  name                   = "bastion-host"
  location               = var.resources_location
  resource_group_name    = azurerm_resource_group.rg.name
  sku                    = "Standard"
  scale_units            = 2 # between 2 and 50
  copy_paste_enabled     = true
  file_copy_enabled      = true
  shareable_link_enabled = true
  tunneling_enabled      = true
  ip_connect_enabled     = false
  tags                   = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_bastion.0.id
    public_ip_address_id = azurerm_public_ip.public_ip_bastion.0.id
  }
}
