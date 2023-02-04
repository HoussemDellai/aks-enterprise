# Subnet for Azure Firewall, without NSG as per Firewall requirements
resource "azurerm_subnet" "subnet_firewall" {
  count                                     = var.enable_firewall ? 1 : 0
  provider                                  = azurerm.subscription_hub
  name                                      = "AzureFirewallSubnet"
  resource_group_name                       = azurerm_virtual_network.vnet_hub.0.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.0.name
  address_prefixes                          = var.cidr_subnet_firewall
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_public_ip" "public_ip_firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub
  name                = "public-ip-firewall"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.0.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = var.tags
}

resource "azurerm_firewall" "firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub
  name                = "firewall-hub"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.0.name
  sku_name            = "AZFW_VNet" # AZFW_Hub
  sku_tier            = "Standard"  # Premium  # "Basic" # 
  # dns_servers         = ["168.63.129.16"]
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.0.id
  zones              = ["1"] # ["1", "2", "3"]
  tags               = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_firewall.0.id
    public_ip_address_id = azurerm_public_ip.public_ip_firewall.0.id
  }
}