resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  sku                 = "Standard"
  admin_enabled       = false # true
  tags                = var.tags

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [
  #     azurerm_user_assigned_identity.container_registry_identity.id
  #   ]
  # }

  # dynamic "georeplications" {
  #   for_each = var.location_one != var.location_two ? [var.location_two] : []

  #   content {
  #     location = georeplications.value
  #     tags     = var.tags
  #   }
  # }
}

resource "azurerm_user_assigned_identity" "identity-kubelet" {
  name                = "${var.aks_name}-agentpool"
  resource_group_name = azurerm_resource_group.rg.name # azurerm_kubernetes_cluster.aks.node_resource_group
  location            = var.resources_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.identity-kubelet.principal_id
  skip_service_principal_aad_check = true
}

# https://github.com/Azure-Samples/aks-multi-cluster-service-mesh/blob/main/istio/container_registry.tf
# resource "azurerm_monitor_diagnostic_setting" "registry_diagnostics_settings" {
#   name                       = "diagnostics-settings"
#   target_resource_id         = azurerm_container_registry.container_registry.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace_one.id

#   log {
#     category = "ContainerRegistryRepositoryEvents"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }

#   log {
#     category = "ContainerRegistryLoginEvents"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = true
#     }
#   }
# }