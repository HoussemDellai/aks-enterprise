terraform {

  required_version = ">= 1.2.2"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.9.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.22.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.1"
    }
  }
}

provider "azurerm" {
  # alias           = "ms-internal"
  # subscription_id = "4b72ed90-7ca3-4e76-8d0f-31a2c0bee7a3" # "Microsoft Internal"
  # tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  # # client_id       = "a0d7fbe0-xxxxxxxxxxxxxxxxxxxxx"
  # # client_secret   = "BAFHTxxxxxxxxxxxxxxxxxxxxxxxxx"

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# Configuring the kubernetes provider
provider "kubernetes" {
  alias                  = "aks-module"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  # Using kubelogin to get an AAD token for the cluster.
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630", # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
      "--client-id",
      "d07d5a72-80e9-4bdd-bd0b-acbec8390e43",
      "--client-secret",
      "mKx8Q~DTWbkjRboimBfWw-atUrYFQL6bLHSGVc7Q",
      "--tenant-id",
      "558506eb-9459-4ef3-b920-ad55c555e729",
      "--login",
      "spn"
    ]
  }
}
# provider "kubernetes" {
#   alias                  = "aks-module"
#   host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# }

provider "helm" {
  alias = "aks-module"
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}