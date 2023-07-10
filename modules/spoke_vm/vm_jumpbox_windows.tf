module "vm_jumpbox_windows" {
  count  = var.enable_vm_jumpbox_windows ? 1 : 0
  source = "../vm_windows"
  providers = {
    # azurerm = azurerm
    azurerm = azurerm.subscription_spoke
  }

  vm_name             = "vm-jumpbox-win"
  resource_group_name = "rg-${var.prefix}-spoke-mgt-vm-win"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_vm.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_spoke.id
  vm_size             = "Standard_B2s"
  admin_username      = "houssem"
  admin_password      = "@Aa123456789"
}