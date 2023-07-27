

# resource "azurerm_public_ip" "pip_onprem" {
#   provider            = azurerm.subscription_onprem
#   name                = "pip-onprem"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"

#   tags = var.tags
# }

# resource "azurerm_network_interface" "nic_onprem" {
#   provider             = azurerm.subscription_onprem
#   name                 = "nic-onprem"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   enable_ip_forwarding = true

#   ip_configuration {
#     name                          = "ipconfig"
#     subnet_id                     = azurerm_subnet.subnet_onprem_mgmt.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip_onprem.id
#   }
# }





# resource "azurerm_virtual_machine" "onprem-vm" {
#   provider              = azurerm.subscription_onprem
#   name                  = "vm-onprem"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.nic_onprem.id]
#   vm_size               = "Standard_B2s"

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "22.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   os_profile {
#     computer_name  = "vm-onprem"
#     admin_username = "houssem"
#     admin_password = "@Aa123456789"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   tags = var.tags
# }


