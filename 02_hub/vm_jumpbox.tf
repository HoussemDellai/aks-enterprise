resource "azurerm_subnet" "subnet_vm" {
  count                                     = var.enable_firewall ? 1 : 0
  provider                                  = azurerm.subscription_hub
  name                                      = "subnet-vm"
  resource_group_name                       = azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = var.cidr_subnet_vm
  private_endpoint_network_policies_enabled = false
}

module "vm_jumpbox" {
  source = "../modules/vm_linux"
  providers = {
    azurerm = azurerm.subscription_hub
  }

  resource_group_name = "rg-${var.prefix}-hub-vm-linux"
  location            = azurerm_resource_group.rg_hub.location
  subnet_id           = azurerm_subnet.subnet_vm.0.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_hub.id
  #   vm_name             = "vm-jumpbox"
  #   vm_size             = "Standard_B2s"
  #   admin_username      = "azureuser"
  #   admin_password      = "P@ssw0rd1234!"
}

module "vm_jumpbox_windows" {
  source = "../modules/vm_windows"
  providers = {
    azurerm = azurerm.subscription_hub
  }

  resource_group_name = "rg-${var.prefix}-hub-vm-windows"
  location            = azurerm_resource_group.rg_hub.location
  subnet_id           = azurerm_subnet.subnet_vm.0.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_hub.id
  #   vm_name             = "vm-jumpbox"
  #   vm_size             = "Standard_B2s"
  #   admin_username      = "azureuser"
  #   admin_password      = "P@ssw0rd1234!"
}

data "azurerm_subscription" "subscription_hub" {
  provider        = azurerm.subscription_hub
  subscription_id = var.subscription_id_hub
}
