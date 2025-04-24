# data azurerm_user_assigned_identity azure_alb_identity {
#     name                = "azure-alb-identity"
#     resource_group_name = "istio-aks"
# }

# resource "helm_release" "alb-controller" {
#   chart            = "alb-controller"
#   namespace        = "azure-alb-system"
#   create_namespace = "false"
#   name             = "alb-controller"
#   version          = "0.5.024542" # "0.4.023971"
#   repository       = "oci://mcr.microsoft.com/application-lb/charts/"
#   atomic           = "true"
#   values = [
#     yamlencode({
#       albController = {
#         podIdentity = {
#           clientID = data.azurerm_user_assigned_identity.azure_alb_identity.client_id
#         }
#       }
#     })
#   ]
# }