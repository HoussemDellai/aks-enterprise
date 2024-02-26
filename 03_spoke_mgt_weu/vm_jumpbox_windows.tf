module "vm_jumpbox_windows" {
  count  = var.enable_vm_jumpbox_windows ? 1 : 0
  source = "../modules/vm_windows"
  providers = {
    azurerm = azurerm
    # azurerm = azurerm.subscription_spoke
  }

  vm_name             = "vm-jumpbox-win"
  resource_group_name = "rg-${var.prefix}-vm-windows"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_vm.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_spoke.id
  vm_size             = "Standard_B2ats_v2" # "Standard_D2s_v3" # "Standard_D4s_v5" # 
  admin_username      = "azureuser"
  admin_password      = "@Aa123456789"
}
