resource "azurerm_monitor_data_collection_endpoint" "dce-log-analytics" {
  name                          = "dce-log-analytics"
  resource_group_name           = azurerm_resource_group.rg-monitoring.name
  location                      = azurerm_resource_group.rg-monitoring.location
  public_network_access_enabled = true
}
