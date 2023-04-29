module "vm_jumpbox_windows" {
  count  = var.enable_vm_jumpbox_windows ? 1 : 0
  source = "../modules/vm_linux"
  providers = {
    azurerm = azurerm.subscription_hub
  }

  vm_name             = "vm-jumpbox-linux"
  resource_group_name = "rg-${var.prefix}-hub-vm-linux"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_vm.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_hub.id
  vm_size             = "Standard_B2s"
  admin_username      = "houssem"
  admin_password      = "@Aa123456789"
}