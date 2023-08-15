# Subnet for Azure Firewall, without NSG as per Firewall requirements
resource "azurerm_subnet" "subnet_firewall" {
  count                                     = var.enable_firewall ? 1 : 0
  provider                                  = azurerm.subscription_hub
  name                                      = "AzureFirewallSubnet"
  resource_group_name                       = azurerm_virtual_network.vnet_hub.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.vnet_hub.name
  address_prefixes                          = var.cidr_subnet_firewall
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "subnet_firewall_mgmt" {
  count                = var.firewall_sku_tier == "Basic" ? 1 : 0
  provider             = azurerm.subscription_hub
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.cidr_subnet_firewall_mgmt
}

resource "azurerm_public_ip" "public_ip_firewall" {
  count               = var.enable_firewall ? 1 : 0
  provider            = azurerm.subscription_hub
  name                = "public-ip-firewall"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = var.tags
}

resource "azurerm_public_ip" "public_ip_firewall_mgmt" {
  provider            = azurerm.subscription_hub
  count               = var.firewall_sku_tier == "Basic" ? 1 : 0
  name                = "public-ip-firewall-mgmt"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
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
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"           # AZFW_Hub
  sku_tier            = var.firewall_sku_tier # "Standard"  # Premium  # "Basic" # 
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.0.id
  zones               = ["1"] # ["1", "2", "3"]
  tags                = var.tags
  # dns_servers         = ["168.63.129.16"]
  # threat_intel_mode = "Alert" # Off, Alert,Deny and ""(empty string). Defaults to Alert.

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_firewall.0.id
    public_ip_address_id = azurerm_public_ip.public_ip_firewall.0.id
  }

  dynamic "management_ip_configuration" { # Firewall with Basic SKU must have Management Ip configuration
    for_each = var.firewall_sku_tier == "Basic" ? ["any_value"] : []
    content {
      name                 = "mgmtconfig"
      subnet_id            = azurerm_subnet.subnet_firewall_mgmt.0.id
      public_ip_address_id = azurerm_public_ip.public_ip_firewall_mgmt.0.id
    }
  }
}
