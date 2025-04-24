resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cni"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks"

  network_profile {
    network_plugin = "azure"
    outbound_type  = "userDefinedRouting"
  }

  default_node_pool {
    name           = "default"
    node_count     = 3
    vm_size        = "Standard_D2s_v5"
    vnet_subnet_id = azurerm_subnet.snet_aks.id
  }

  identity {  
    type = "SystemAssigned"
  }
}
