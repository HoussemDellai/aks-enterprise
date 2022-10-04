resource "azurerm_public_ip" "public_ip_firewall" {
  provider            = azurerm.subscription_hub # .ms-internal
  name                = "public-ip-firewall"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  provider            = azurerm.subscription_hub # .ms-internal
  name                = "firewall-hub"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg_hub.name
  sku_name            = "AZFW_VNet" # AZFW_Hub
  sku_tier            = "Standard"  # Premium 
  # firewall_policy_id  

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_firewall.id
    public_ip_address_id = azurerm_public_ip.public_ip_firewall.id
  }
}

# resource "azurerm_firewall_policy" "aks" {
#   name                = "AKSpolicy"
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

# output "fw_policy_id" {
#     value = azurerm_firewall_policy.aks.id
# }

# # Rules Collection Group

# resource "azurerm_firewall_policy_rule_collection_group" "AKS" {
#   name               = "aks-rcg"
#   firewall_policy_id = azurerm_firewall_policy.aks.id
#   priority           = 200
#   application_rule_collection {
#     name     = "aks_app_rules"
#     priority = 205
#     action   = "Allow"
#     rule {
#       name = "aks_service"
#       protocols {
#         type = "Https"
#         port = 443
#       }
#       source_addresses      = ["10.1.0.0/16"]
#       destination_fqdn_tags = ["AzureKubnernetesService"]
#     }
#   }

#   network_rule_collection {
#     name     = "aks_network_rules"
#     priority = 201
#     action   = "Allow"
#     rule {
#       name                  = "https"
#       protocols             = ["TCP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["443"]
#     }
#     rule {
#       name                  = "dns"
#       protocols             = ["UDP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["53"]
#     }
#     rule {
#       name                  = "time"
#       protocols             = ["UDP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["123"]
#     }
#     rule {
#       name                  = "tunnel_udp"
#       protocols             = ["UDP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["1194"]
#     }
#     rule {
#       name                  = "tunnel_tcp"
#       protocols             = ["TCP"]
#       source_addresses      = ["10.1.0.0/16"]
#       destination_addresses = ["*"]
#       destination_ports     = ["9000"]
#     }
#   }

# }