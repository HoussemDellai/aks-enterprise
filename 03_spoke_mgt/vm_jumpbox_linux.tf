resource "azurerm_subnet" "subnet_vm" {
  name                 = "subnet-vm"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_mgt.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_mgt.resource_group_name
  address_prefixes     = var.cidr_subnet_mgt
}

module "vm_jumpbox_linux" {
  count  = var.enable_vm_jumpbox_linux ? 1 : 0
  source = "../modules/vm_linux"
  providers = {
    azurerm = azurerm.subscription_hub
  }

  vm_name             = "vm-jumpbox-linux"
  resource_group_name = "rg-${var.prefix}-mgt-vm-linux"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_vm.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_hub.id
  vm_size             = "Standard_B2s"
  admin_username      = "houssem"
  admin_password      = "@Aa123456789"
}

data "azurerm_subscription" "subscription_hub" {
  subscription_id = var.subscription_id_hub
}