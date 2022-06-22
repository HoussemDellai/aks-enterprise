# Create Application registration for kubecost
resource "azuread_application" "kubecost" {
  display_name = "kubecost"
}

# Create Service principal for kubecost
resource "azuread_service_principal" "kubecost" {
  application_id = azuread_application.kubecost.application_id
}

# Create kubecost's Service principal password
resource "azuread_service_principal_password" "kubecost" {
  service_principal_id = azuread_service_principal.kubecost.id
}

# Create kubecost custom role
resource "azurerm_role_definition" "kubecost" {
  name        = "rate_card_query_kubecost"
  scope       = data.azurerm_subscription.current.id
  description = "kubecost Rate Card query role"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.Commerce/RateCard/read",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

# Assign kubecost's custom role at the subscription level
resource "azurerm_role_assignment" "kubecost" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.kubecost.name
  principal_id         = azuread_service_principal.kubecost.object_id
}