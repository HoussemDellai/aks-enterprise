# resource azuread_application example {
#   display_name = "example"
# }

# # https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential
# resource azuread_application_federated_identity_credential directory_role_app {
#   count                 = var.enable_aks_cluster ? 1 : 0
#   application_object_id = azuread_application.example.object_id
#   display_name          = "kubernetes-federated-credential"
#   description           = "Kubernetes service account federated credential"
#   audiences             = ["api://AzureADTokenExchange"]
#   subject               = "system:serviceaccount:default:workload-identity-sa" #TODO: this is hardcoded
#   issuer                = azurerm_kubernetes_cluster.aks.0.oidc_issuer_url
# }
