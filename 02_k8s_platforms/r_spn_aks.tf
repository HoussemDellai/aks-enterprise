# create SPN for deploying Helm charts and Kubernetes objects into AKS from Terraform providers

resource azuread_application" "app_aks_helm" {
  display_name = "spn_aks_helm"
}

resource azuread_service_principal" "spn_aks_helm" {
  application_id = azuread_application.app_aks_helm.application_id
}

resource azuread_service_principal_password" "password_spn_aks_helm" {
  service_principal_id = azuread_service_principal.spn_aks_helm.id
}

# add SPN into AKS admin group
resource azuread_group_member" "spn_aks_helm_aks_admin" {
  group_object_id  = data.azuread_group.aks_admins.id
  member_object_id = azuread_service_principal.spn_aks_helm.id
}

# resource azuread_group" "aks_admins" {
#   display_name     = var.aad_group_aks_admins
#   security_enabled = true
#   owners           = [data.azuread_client_config.current.object_id]

#   members = [
#     data.azuread_client_config.current.object_id,
#     # azuread_service_principal.spn_velero.object_id
#   ]
# }