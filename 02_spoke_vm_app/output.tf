# vm private IP
output "vm_private_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

# vm public IP
output "vm_public_ip" {
  value = azurerm_public_ip.pip_vm.ip_address
}