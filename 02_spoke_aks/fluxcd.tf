# # https://github.com/pauldotyu/awesome-aks/blob/main/2023-09-28-bootstrap-flux-v2-on-aks/fluxcd.tf

# ################################################################################
# # Installs FluxCD AKS extension with GitRepository and Kustomization resources #
# ################################################################################

# resource "azurerm_kubernetes_cluster_extension" "example" {
#   name              = "aks-${local.name}-fluxcd"
#   cluster_id        = azurerm_kubernetes_cluster.example.id
#   extension_type    = "microsoft.flux"
#   release_namespace = "flux-system"

#   configuration_settings = {
#     "image-automation-controller.enabled" = true,
#     "image-reflector-controller.enabled"  = true,
#     "notification-controller.enabled"     = true,
#   }

#   # depends_on = [azapi_update_resource.example]
# }

# resource "kubernetes_secret" "example" {
#   metadata {
#     name      = "${var.repo_name}-repo-secrets"
#     namespace = "flux-system"
#   }

#   data = {
#     password = var.gh_token
#     username = var.gh_user
#   }

#   depends_on = [
#     local_file.kubeconfig,
#     azurerm_kubernetes_cluster_extension.example
#   ]
# }

# resource "azurerm_kubernetes_flux_configuration" "example" {
#   name                              = var.repo_name
#   cluster_id                        = azurerm_kubernetes_cluster.example.id
#   namespace                         = "flux-system"
#   scope                             = "cluster"
#   continuous_reconciliation_enabled = true

#   git_repository {
#     url                      = "https://github.com/${var.gh_user}/${var.repo_name}"
#     reference_type           = "branch"
#     reference_value          = var.repo_branch
#     local_auth_reference     = kubernetes_secret.example.metadata[0].name
#     sync_interval_in_seconds = 60
#   }

#   kustomizations {
#     name                       = "dev-app"
#     path                       = "./overlays/dev"
#     garbage_collection_enabled = true
#     recreating_enabled         = true
#     sync_interval_in_seconds   = 60
#   }

#   kustomizations {
#     name                       = "dev-image"
#     path                       = "./clusters/dev/image-update"
#     garbage_collection_enabled = true
#     recreating_enabled         = true
#     sync_interval_in_seconds   = 60
#     depends_on                 = ["dev-app"]
#   }

#   kustomizations {
#     name                       = "dev-flagger"
#     path                       = "./clusters/dev/flagger"
#     garbage_collection_enabled = true
#     recreating_enabled         = true
#     sync_interval_in_seconds   = 60
#     depends_on                 = ["dev-app"]
#   }

#   kustomizations {
#     name                       = "dev-canary-store-front"
#     path                       = "./overlays/dev/canary"
#     garbage_collection_enabled = true
#     recreating_enabled         = true
#     sync_interval_in_seconds   = 60
#     depends_on = [
#       "dev-app",
#       "dev-flagger",
#     ]
#   }

#   depends_on = [
#     kubernetes_secret.example
#   ]
# }