resource azurerm_network_interface nic_vm_jumpbox_windows {
  count               = var.enable_vm_jumpbox_windows ? 1 : 0
  name                = "nic-vm-jumpbox-windows"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_mgt.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource azurerm_windows_virtual_machine vm_jumpbox_windows {
  count                 = var.enable_vm_jumpbox_windows ? 1 : 0
  name                  = "vm-jumpbox-win"
  resource_group_name   = azurerm_resource_group.rg_spoke_mgt.name
  location              = var.resources_location
  size                  = "Standard_B2s" # "Standard_D2s_v5" # "Standard_D2ads_v5"
  admin_username        = "houssem"
  admin_password        = "@Aa123456789"
  network_interface_ids = [azurerm_network_interface.nic_vm_jumpbox_windows.0.id]
  tags                  = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

# resource azurerm_virtual_machine_extension vm_extension_windows {
#   count                = var.enable_vm_jumpbox_windows ? 1 : 0
#   name                 = "vm-extension-windows"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm_jumpbox_windows.0.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
#     }
# SETTINGS
# }