resource "azurerm_log_analytics_workspace" "workspace" {
  count               = var.enable_container_insights ? 1 : 0
  name                = var.log_analytics_workspace_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018" # PerGB2018, Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation
  retention_in_days   = 30          # possible values are either 7 (Free Tier only) or range between 30 and 730
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "solution" {
  count                 = var.enable_container_insights ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.workspace.0.location
  resource_group_name   = azurerm_log_analytics_workspace.workspace.0.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.workspace.0.id
  workspace_name        = azurerm_log_analytics_workspace.workspace.0.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
  tags = var.tags
}