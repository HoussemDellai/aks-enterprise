#--------------------------------------------------------------------------------
# Secret Store CSI Driver for Key Vault
#--------------------------------------------------------------------------------

resource "helm_release" "pod_identity" {
  name             = "pod-identity"
  repository       = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart            = "aad-pod-identity"
  namespace        = "default" # TODO: Change namespace
  create_namespace = true
}

resource "helm_release" "csi_keyvault" {
  name             = "csi-keyvault"
  repository       = "https://azure.github.io/secrets-store-csi-driver-provider-azure/charts"
  chart            = "csi-secrets-store-provider-azure"
  namespace        = "csi-driver"
  create_namespace = true
}

# resource "helm_release" "nginx_ingress" {
#   name = "nginx-ingress-controller"

#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "nginx-ingress-controller"

#   set {
#     name  = "service.type"
#     value = "ClusterIP"
#   }
# }