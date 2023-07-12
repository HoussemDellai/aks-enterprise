module "vm_jumpbox_windows" {
  count  = var.enable_vm_jumpbox_windows ? 1 : 0
  source = "../modules/vm_windows"
  providers = {
    azurerm = azurerm.subscription_hub
  }

  vm_name             = "vm-jumpbox-win"
  resource_group_name = "rg-${var.prefix}-vm-windows"
  location            = azurerm_resource_group.rg_hub.location
  subnet_id           = azurerm_subnet.subnet_vm.0.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_hub.id
  vm_size             = "Standard_D2s_v5" # "Standard_B2s"
  admin_username      = "houssem"
  admin_password      = "@Aa123456789"
}