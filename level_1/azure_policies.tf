# resource azurerm_user_assigned_identity" "identity_azure_policy" {
#   count               = var.enable_monitoring ? 1 : 0
#   name                = "identity-azure-policy"
#   resource_group_name = azurerm_resource_group.rg_spoke_mgt.0.name #todo: change RG
#   location            = var.resources_location
#   tags                = var.tags
# }

# resource azurerm_role_assignment" "role_contributor_azure_policy" {
#   count                            = var.enable_aks_cluster ? 1 : 0
#   scope                            = data.azurerm_subscription.subscription_spoke.id
#   role_definition_name             = "Contributor"
#   principal_id                     = azurerm_user_assigned_identity.identity_azure_policy.0.principal_id
#   skip_service_principal_aad_check = true
# }

# # data "azurerm_policy_definition" "policy_configure_traffic_analytics" {
# #   display_name = "Configure network security groups to use specific workspace, storage account and flowlog retention policy for traffic analytics"
# # }

# # /providers/Microsoft.Authorization/policyDefinitions/5e1cd26a-5090-4fdb-9d6a-84a90335e22d
# resource azurerm_subscription_policy_assignment" "policy_configure_traffic_analytics" {
#   name                 = "policy-configure-traffic-analytics"
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/5e1cd26a-5090-4fdb-9d6a-84a90335e22d"
#   subscription_id      = data.azurerm_subscription.subscription_spoke.id
#   enforce              = true # var.enable_monitoring
#   display_name         = "policy-configure-traffic-analytics-for-nsg"
#   # description          = "Configure network security groups to use specific workspace, storage account and flowlog retention policy for traffic analytics. If it already has traffic analytics enabled, then policy will overwrite its existing settings with the ones provided during policy creation. Traffic analytics is a cloud-based solution that provides visibility into user and application activity in cloud networks."
#   location = var.resources_location
#   non_compliance_message {
#     content = "Resource not compliant as per policy_configure_traffic_analytics in Terraform"
#   }

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.identity_azure_policy.0.id]
#   }

#   parameters = jsonencode(
#     {
#       "effect" : {
#         "value" : "DeployIfNotExists"
#       },
#       "nsgRegion" : {
#         "value" : "${var.resources_location}"
#       },
#       "storageId" : {
#         "value" : "${azurerm_storage_account.network_log_data.0.id}"
#       },
#       "timeInterval" : {
#         "value" : "10"
#       },
#       "workspaceResourceId" : {
#         "value" : "${azurerm_log_analytics_workspace.workspace.0.id}"
#       },
#       "workspaceRegion" : {
#         "value" : "${var.resources_location}"
#       },
#       "workspaceId" : {
#         "value" : "${azurerm_log_analytics_workspace.workspace.0.workspace_id}"
#       },
#       "networkWatcherRG" : {
#         "value" : "${data.azurerm_network_watcher.network_watcher_regional.resource_group_name}"
#       },
#       "networkWatcherName" : {
#         "value" : "${data.azurerm_network_watcher.network_watcher_regional.name}"
#       },
#       "retentionDays" : {
#         "value" : "7"
#       }
#   })
# }

# resource azurerm_subscription_policy_remediation" "remediation_configure_traffic_analytics" {
#   name                 = "remediation-configure-traffic-analytics"
#   subscription_id      = data.azurerm_subscription.subscription_spoke.id
#   policy_assignment_id = azurerm_subscription_policy_assignment.policy_configure_traffic_analytics.id
# }