# resource azurerm_subscription_policy_exemption exemption_network_watcher {
#   name                 = "Exemption_Network_Watcher_should_be_enabled"
#   subscription_id      = data.azurerm_subscription.subscription_spoke.id
#   policy_assignment_id = "/subscriptions/0cb12691-4f8e-4a66-abab-4481e2f0517e/providers/Microsoft.Authorization/policyAssignments/SecurityCenterBuiltIn"
#   exemption_category   = "Mitigated" # "Waiver"
#   expires_on           = timeadd(formatdate(time_static.time_now.rfc3339, "yyyy-MM-ddTHH:mm:ssZ"), "1h") # timestamp() # "yyyy-MM-ddTHH:mm:ssZ"
# }

# resource time_static time_now {
#   triggers = {
#     # Save the time each switch of an AMI id
#     # ami_id = azurerm_subscription_policy_exemption.exemption_network_watcher.id
#   }
# }