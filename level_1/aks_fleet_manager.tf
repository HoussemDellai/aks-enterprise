# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_fleet_manager
resource azurerm_kubernetes_fleet_manager" "fleet_manager" {
  count = var.enable_fleet_manager ? 1 : 0
  hub_profile {
    dns_prefix = "aksfleet"
  }

  location            = var.resources_location
  name                = "aksfleet"
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name
  tags                = var.tags
}
