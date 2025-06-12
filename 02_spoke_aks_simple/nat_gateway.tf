# resource "azurerm_nat_gateway" "nat-gateway" {
#   name                    = "nat-gateway"
#   location                = azurerm_resource_group.rg.location
#   resource_group_name     = azurerm_resource_group.rg.name
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 10
#   zones                   = ["1"] # Only one AZ can be defined.
# }

# resource "azurerm_subnet_nat_gateway_association" "association" {
#   subnet_id      = azurerm_subnet.snet_aks.id # azurerm_subnet.subnet_nodes_user_nodepool["poolappsamd"].id
#   nat_gateway_id = azurerm_nat_gateway.nat-gateway.id
# }

# resource "azurerm_public_ip_prefix" "pip-prefix-nat-gateway" {
#   name                = "pip-prefix-nat-gateway"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "Standard"
#   ip_version          = "IPv4" # "IPv6"
#   prefix_length       = 31     # between 0 (4,294,967,296 addresses) and 31 (2 addresses)
#   zones               = ["1"]  # same zone as the NAT Gateway
# }

# resource "azurerm_nat_gateway_public_ip_prefix_association" "natgw-pip-prefix-association" {
#   nat_gateway_id      = azurerm_nat_gateway.nat-gateway.id
#   public_ip_prefix_id = azurerm_public_ip_prefix.pip-prefix-nat-gateway.id
# }