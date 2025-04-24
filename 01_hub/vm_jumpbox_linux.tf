module "vm_jumpbox_linux" {
  count  = var.enable_vm_jumpbox_linux ? 1 : 0
  source = "../modules/vm_linux"
  providers = {
    azurerm = azurerm.subscription_hub
  }

  vm_name             = "vm-jumpbox-linux"
  resource_group_name = "rg-${var.prefix}-vm-linux"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_vm.0.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_hub.id
  vm_size             = "Standard_B2ats_v2"
  admin_username      = "azureuser"
  admin_password      = "@Aa123456789"
  enable_public_ip    = false
}