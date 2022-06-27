resource "azurerm_log_analytics_workspace" "aks" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = var.log_analytics_workspace_name
    location            = var.resources_location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = "PerGB2018" # PerGB2018, Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "aks" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = azurerm_resource_group.k8s.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

# resource "azurerm_resource_group" "example" {
#   name     = "k8s-log-analytics-test"
#   location = "West Europe"
# }

# resource "random_id" "workspace" {
#   keepers = {
#     # Generate a new id each time we switch to a new resource group
#     group_name = azurerm_resource_group.example.name
#   }

#   byte_length = 8
# }

# resource "azurerm_log_analytics_workspace" "example" {
#   name                = "k8s-workspace-${random_id.workspace.hex}"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

# resource "azurerm_log_analytics_solution" "example" {
#   solution_name         = "ContainerInsights"
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   workspace_resource_id = azurerm_log_analytics_workspace.example.id
#   workspace_name        = azurerm_log_analytics_workspace.example.name

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ContainerInsights"
#   }
# }