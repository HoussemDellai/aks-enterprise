# data "azuread_service_principal" "aks_aad_server" {
#   display_name = "Azure Kubernetes Service AAD Server"
# }

# resource "azuread_application" "app" {
#   display_name = var.spn_name
# }

# # https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal
# resource "azuread_service_principal" "spn" {
#   application_id = azuread_application.app.application_id
# }

# resource "azuread_service_principal_password" "spn_password" {
#   service_principal_id = azuread_service_principal.spn.id
# }

# resource "azuread_group" "aks_admins" {
#   display_name     = var.aad_group_aks_admins
#   security_enabled = true
#   owners           = [data.azuread_client_config.current.object_id]

#   members = [
#     data.azuread_client_config.current.object_id,
#     azuread_service_principal.spn.object_id,
#   ]
# }




# # https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
# resource "helm_release" "nginx_ingress_controller" {
#   name             = "nginx-ingress-controller"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   version          = "4.7.1"
#   namespace        = "ingress"
#   create_namespace = "true"

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }
#   set {
#     name  = "controller.autoscaling.enabled"
#     value = "true"
#   }
#   set {
#     name  = "controller.autoscaling.minReplicas"
#     value = "2"
#   }
#   set {
#     name  = "controller.autoscaling.maxReplicas"
#     value = "10"
#   }
# }