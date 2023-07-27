# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg_onprem" {
  provider            = azurerm.subscription_onprem
  name                = "nsg-onprem"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "association_mgmt_nsg" {
  provider                  = azurerm.subscription_onprem
  subnet_id                 = azurerm_subnet.subnet_onprem_mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg_onprem.id
}