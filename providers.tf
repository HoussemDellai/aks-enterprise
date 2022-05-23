terraform {

  required_version = ">=1.1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# provider "helm" {
#   alias = "aks"
#   kubernetes {
#     host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
#     client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#     client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
#   }
# }