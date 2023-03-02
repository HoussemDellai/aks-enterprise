resource "azurerm_virtual_network" "vnet_spoke_aks" {
  name                = "vnet-spoke-aks"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  address_space       = var.cidr_vnet_spoke_aks
  dns_servers         = var.enable_hub_spoke ? [data.terraform_remote_state.hub.0.outputs.firewall_private_ip] : null
  # dns_servers         = var.enable_firewall ? [azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address] : null
  tags = var.tags
}

resource "azurerm_subnet" "subnet_spoke_aks_pe" {
  count                = var.enable_private_acr || var.enable_private_keyvault ? 1 : 0
  name                 = "subnet-spoke-aks-pe"
  virtual_network_name = azurerm_virtual_network.vnet_spoke_aks.name
  resource_group_name  = azurerm_virtual_network.vnet_spoke_aks.resource_group_name
  address_prefixes     = var.cidr_subnet_spoke_aks_pe
}