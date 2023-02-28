resource azurerm_user_assigned_identity" "identity_vm_linux" {
  count               = var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "identity_vm_linux"
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.name
  location            = var.resources_location
  tags                = var.tags
}

resource azurerm_role_assignment" "role_identity_vm_linux_contributor" {
  count                            = var.enable_vm_jumpbox_linux ? 1 : 0
  scope                            = data.azurerm_subscription.subscription_spoke.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity_vm_linux.0.principal_id
  skip_service_principal_aad_check = true
}

resource azurerm_network_interface" "nic_vm_jumpbox_linux" {
  count               = var.enable_vm_jumpbox_linux ? 1 : 0
  name                = "nic-vm-jumpbox-linux"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_mgt.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_mgt.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource azurerm_linux_virtual_machine" "vm_jumpbox_linux" {
  count                           = var.enable_vm_jumpbox_linux ? 1 : 0
  name                            = "vm-jumpbox-linux"
  resource_group_name             = azurerm_resource_group.rg_spoke_mgt.name
  location                        = var.resources_location
  size                            = "Standard_B2s" # "Standard_D2s_v5" # "Standard_D2ads_v5"
  disable_password_authentication = false
  admin_username                  = "houssem"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic_vm_jumpbox_linux.0.id]
  tags                            = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer" # "0001-com-ubuntu-server-jammy" # "0001-com-ubuntu-minimal-jammy"
    sku       = "18.04-LTS"    # "22_04-lts-gen2" # "minimal-22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity_vm_linux.0.id]
  }

  # az vm image list --publisher Canonical --offer 0001-com-ubuntu-pro-jammy -s pro-22_04-lts-gen2 --all
  # az vm image terms accept --urn "Canonical:0001-com-ubuntu-pro-jammy:pro-22_04-lts-gen2:22.04.202209211"
  # plan {
  #   name = "22_04-lts-gen2" # "minimal-22_04-lts-gen2"
  #   product = "0001-com-ubuntu-server-jammy" # "0001-com-ubuntu-minimal-jammy"
  #   publisher = "Canonical"
  # }
}

resource azurerm_virtual_machine_extension" "vm_extension_linux" {
  count                = var.enable_vm_jumpbox_linux ? 1 : 0
  name                 = "vm_extension_linux"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm_jumpbox_linux.0.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  tags                 = var.tags
  settings             = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/HoussemDellai/aks-appgateway/network-flow-logs/level_1/vm-install-cli-tools.sh"],
      "commandToExecute": "./vm-install-cli-tools.sh"
    }
SETTINGS
  # settings = <<SETTINGS
  # {
  #   "fileUris": ["https://${azurerm_storage_account.storage.0.name}.blob.core.windows.net/${azurerm_storage_container.container.0.name}/vm-install-cli-tools.sh"],
  #   "commandToExecute": "./install-cli-tools.sh"
  # }
  # SETTINGS
}

#todo : diag settings