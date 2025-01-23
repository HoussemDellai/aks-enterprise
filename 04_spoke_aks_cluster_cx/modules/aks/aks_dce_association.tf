resource "azurerm_monitor_data_collection_rule_association" "dcra-dce-log-analytics-aks" {
  name                        = "configurationAccessEndpoint" # name is required when data_collection_rule_id is specified. And when data_collection_endpoint_id is specified, the name is populated with configurationAccessEndpoint
  target_resource_id          = azurerm_kubernetes_cluster.aks.id
  data_collection_endpoint_id = var.data_collection_endpoint_id
}
