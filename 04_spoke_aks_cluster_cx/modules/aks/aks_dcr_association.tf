resource "azurerm_monitor_data_collection_rule_association" "dcra-dcr-log-analytics-aks" {
  name                    = "dcra-dcr-log-analytics-aks"
  target_resource_id      = azurerm_kubernetes_cluster.aks.id
  data_collection_rule_id = var.data_collection_rule_id
}