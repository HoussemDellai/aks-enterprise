resource "azurerm_subnet" "subnet_jumpbox" {
  name                 = "internal"
  resource_group_name  = azurerm_virtual_network.vnet_spoke.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_spoke.name
  address_prefixes     = ["10.5.0.0/24"] #TODO
}

resource "azurerm_network_interface" "nic_vm_jumpbox" {
  name                = "nic-vm-jumpbox"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_jumpbox.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_jumpbox" {
  name                = "vm-jumpbox"
  resource_group_name = azurerm_resource_group.rg_spoke_vm.name
  location            = var.resources_location
  size                = "Standard_D2ads_v5"
  admin_username      = "houssem"
  admin_password      = "@Aa123456789"
  network_interface_ids = [
    azurerm_network_interface.nic_vm_jumpbox.id,
  ]

  os_disk { #TODO: replace with vm-devbox OS Disk
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-ent-g2"
    version   = "latest"
  }
}