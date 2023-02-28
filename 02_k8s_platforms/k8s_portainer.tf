# Create the kubecost namespace
resource kubernetes_namespace" "portainer" {
  provider = kubernetes.aks-module
  metadata {
    name = "portainer"
  }
}

# https://docs.portainer.io/start/install/server/kubernetes/baremetal
resource helm_release" "portainer" {
  provider   = helm.aks-module
  name       = "portainer"
  chart      = "portainer"
  namespace  = kubernetes_namespace.portainer.metadata.0.name
  repository = "https://portainer.github.io/k8s/"

  set {
    name  = "tls.force"
    value = true
  }
}