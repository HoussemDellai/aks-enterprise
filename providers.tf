
terraform {

  required_version = ">= 1.2.8"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.20.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.28.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

provider "azurerm" {
  # alias           = "ms-azure"
  subscription_id = "17b12858-3960-4e6f-a663-a06fdae23428" # Microsoft-Azure-0
  tenant_id       = "558506eb-9459-4ef3-b920-ad55c555e729"
  # alias           = "ms-internal"
  # subscription_id = "4b72ed90-7ca3-4e76-8d0f-31a2c0bee7a3" # "Microsoft Internal"
  # tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  # # client_id       = "a0d7fbe0-xxxxxxxxxxxxxxxxxxxxx"
  # # client_secret   = "BAFHTxxxxxxxxxxxxxxxxxxxxxxxxx"
  auxiliary_tenant_ids = ["72f988bf-86f1-41af-91ab-2d7cd011db47"]

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azurerm" {
  alias           = "ms-internal"
  subscription_id = "4b72ed90-7ca3-4e76-8d0f-31a2c0bee7a3"
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  # client_id       = "a0d7fbe0-dca2-4848-b6ac-ad15e2c31840"
  # client_secret   = "BAFHTR3235FEHsdfb%#$W%weF#@a"
  auxiliary_tenant_ids = ["558506eb-9459-4ef3-b920-ad55c555e729"]
  features {}
}