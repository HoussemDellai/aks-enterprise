resource "azurerm_network_interface" "nic_vm_jumpbox_windows" {
  count               = var.enable_vm_jumpbox_windows ? 1 : 0
  name                = "nic-vm-jumpbox-windows"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_vm.0.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_jumpbox.0.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_jumpbox_windows" {
  count                            = var.enable_vm_jumpbox_windows ? 1 : 0
  name                             = "vm-jumpbox-win"
  resource_group_name              = azurerm_resource_group.rg_spoke_vm.0.name
  location                         = var.resources_location
  size                             = "Standard_D2ads_v5"
  admin_username                   = "houssem"
  admin_password                   = "@Aa123456789"
  network_interface_ids            = [azurerm_network_interface.nic_vm_jumpbox_windows.0.id]


  os_disk { #TODO: replace with vm-devbox OS Disk
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-ent-g2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

# "properties": {
#     "vmId": "f8180c1b-a91a-4f53-b90e-2e17709934ef",
#     "hardwareProfile": {
#         "vmSize": "Standard_D2ads_v5"
#     },
#     "storageProfile": {
#         "osDisk": {
#             "osType": "Windows",
#             "name": "vm-devbox_OsDisk",
#             "createOption": "Attach",
#             "caching": "ReadWrite",
#             "managedDisk": {
#                 "storageAccountType": "StandardSSD_LRS",
#                 "id": "/subscriptions/59d574d4-1c03-4092-ab22-312ed594eec9/resourceGroups/RG-DISK-OS-VM-DEVBOX/providers/Microsoft.Compute/disks/vm-devbox_OsDisk"
#             },
#             "deleteOption": "Detach",
#             "diskSizeGB": 256
#         },
#         "dataDisks": []
#     },