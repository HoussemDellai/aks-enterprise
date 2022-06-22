resource "azuread_group" "aks_admins" {
  display_name     = var.aad_group_aks_admins
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]

  members = [
    data.azuread_client_config.current.object_id,
    azuread_service_principal.spn_velero.object_id,
  ]
}