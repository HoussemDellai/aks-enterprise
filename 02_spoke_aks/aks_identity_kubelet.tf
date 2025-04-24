resource "azurerm_user_assigned_identity" "identity-kubelet" {
  name                = "identity-kubelet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "role-acrpull" {
  scope                            = data.terraform_remote_state.spoke_aks.outputs.acr.id # azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.identity-kubelet.principal_id
  skip_service_principal_aad_check = true
}