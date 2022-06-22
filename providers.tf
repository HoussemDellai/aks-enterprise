terraform {

  required_version = ">= 1.2.2"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.10.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.22.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
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

provider "kubernetes" {
  alias                  = "aks-module"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  # config_path = "~/.kube/config"

  # using kubelogin to get an AAD token for the cluster.
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      data.azuread_service_principal.aks_aad_server.application_id, # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
      "--client-id",
      azuread_service_principal.spn_velero.application_id, # SPN App Id created via terraform
      "--client-secret",
      azuread_service_principal_password.password_spn_velero.value,
      "--tenant-id",
      data.azurerm_subscription.current.tenant_id, # AAD Tenant Id
      "--login",
      "spn"
    ]
  }
}

provider "helm" {
  alias = "aks-module"
  kubernetes {
    # host                   = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    # cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
    # config_path = "~/.kube/config"

    # using kubelogin to get an AAD token for the cluster.
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--environment",
        "AzurePublicCloud",
        "--server-id",
        data.azuread_service_principal.aks_aad_server.application_id, # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
        "--client-id",
        azuread_service_principal.spn_velero.application_id, # SPN App Id created via terraform
        "--client-secret",
        azuread_service_principal_password.password_spn_velero.value,
        "--tenant-id",
        data.azurerm_subscription.current.tenant_id, # AAD Tenant Id
        "--login",
        "spn"
      ]
    }
  }
}