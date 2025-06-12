module "vm_jumpbox_linux" {
  source = "../modules/vm_linux"

  vm_name             = "vm-jumpbox-linux"
  resource_group_name = "rg-spoke-aks-vm-linux"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet_aks.id
  tags                = null
  subscription_id     = data.azurerm_subscription.subscription_spoke.id
  vm_size             = "Standard_D2ads_v5"
  admin_username      = "azureuser"
  admin_password      = "@Aa123456789"
  enable_public_ip    = false
}

data "azurerm_subscription" "subscription_spoke" {}