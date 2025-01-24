resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# resource "azurerm_user_assigned_identity" "identity_vm" {
#   name                = "identity-vm"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   tags                = var.tags
# }

resource "azurerm_role_assignment" "role_contributor" {
  scope                            = var.subscription_id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_windows_virtual_machine.vm.identity.0.principal_id # azurerm_user_assigned_identity.identity_vm.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "role_azure_kubernetes_service_rbac_clusteradmin" {
  scope                            = var.subscription_id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id                     = azurerm_windows_virtual_machine.vm.identity.0.principal_id # azurerm_user_assigned_identity.identity_vm.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_network_interface" "nic_vm" {
  name                = "nic-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic_vm.id]
  priority              = "Spot"
  eviction_policy       = "Deallocate"
  tags                  = var.tags

  custom_data = filebase64("../scripts/install-tools-windows-vm-choco.ps1")

  os_disk {
    name                 = "disk-os${var.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  identity {
    type         = "SystemAssigned" # "UserAssigned"
    # identity_ids = [azurerm_user_assigned_identity.identity_vm.id]
  }

  lifecycle {
    ignore_changes = [
      custom_data
    ]
  }
}

resource "azurerm_virtual_machine_extension" "cse" {
  name                 = "cse"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  tags     = var.tags

  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/install.ps1; c:/azuredata/install.ps1\""
    }
    SETTINGS
}

# resource "azurerm_virtual_machine_extension" "cse" {
#   name                       = "cse"
#   virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.10"
#   auto_upgrade_minor_version = "true"
#   tags     = var.tags
#   # publisher            = "Microsoft.Azure.Extensions"
#   # type                 = "CustomScript"
#   # type_handler_version = "2.1"

#   settings = <<SETTINGS
#     {
#       "fileUris": ["https://raw.githubusercontent.com/HoussemDellai/aks-enterprise/main/scripts/install-tools-windows-vm.ps1"],
#       "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file install-tools-windows-vm.ps1"
#     }
# SETTINGS
#   # powershell -ExecutionPolicy Unrestricted -file build-agent.ps1
# }
