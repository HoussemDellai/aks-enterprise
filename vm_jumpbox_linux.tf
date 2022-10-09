resource "azurerm_network_interface" "nic_vm_jumpbox_linux" {
  count               = var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "nic-vm-jumpbox-linux"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_vm.0.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_jumpbox.0.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_jumpbox_linux" {
  count                            = var.enable_vm_jumpbox_linux ? 1 : 0
  name                             = "vm-jumpbox-linux"
  resource_group_name              = azurerm_resource_group.rg_spoke_vm.0.name
  location                         = var.resources_location
  size                             = "Standard_D2ads_v5"
  disable_password_authentication  = false
  admin_username                   = "houssem"
  admin_password                   = "@Aa123456789"
  network_interface_ids            = [azurerm_network_interface.nic_vm_jumpbox_linux.0.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer" # "0001-com-ubuntu-server-jammy" # "0001-com-ubuntu-minimal-jammy"
    sku       = "18.04-LTS" # "22_04-lts-gen2" # "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

# az vm image list --publisher Canonical --offer 0001-com-ubuntu-pro-jammy -s pro-22_04-lts-gen2 --all
# az vm image terms accept --urn "Canonical:0001-com-ubuntu-pro-jammy:pro-22_04-lts-gen2:22.04.202209211"
  # plan {
  #   name = "22_04-lts-gen2" # "minimal-22_04-lts-gen2"
  #   product = "0001-com-ubuntu-server-jammy" # "0001-com-ubuntu-minimal-jammy"
  #   publisher = "Canonical"
  # }
}