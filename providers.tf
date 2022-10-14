
terraform {

  required_version = ">= 1.2.8"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.26.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.29.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "1.0.0"
    }
  }
}

provider "azurerm" {
  # alias           = "subscription_spoke" # default
  subscription_id = "59d574d4-1c03-4092-ab22-312ed594eec9"
  tenant_id       = "558506eb-9459-4ef3-b920-ad55c555e729"
  # client_id       = "a0d7fbe0-xxxxxxxxxxxxxxxxxxxxx"
  # client_secret   = "BAFHTxxxxxxxxxxxxxxxxxxxxxxxxx"
  # auxiliary_tenant_ids = ["72f988bf-86f1-41af-91ab-2d7cd011db47"] # (Optional) List of auxiliary Tenant IDs required for multi-tenancy and cross-tenant scenarios. This can also be sourced from the ARM_AUXILIARY_TENANT_IDS Environment Variable.

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy          = true
      recover_soft_deleted_key_vaults       = true
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
  }
}

provider "azurerm" {
  alias           = "subscription_hub"
  subscription_id = "59d574d4-1c03-4092-ab22-312ed594eec9" # "17b12858-3960-4e6f-a663-a06fdae23428" # "4b72ed90-7ca3-4e76-8d0f-31a2c0bee7a3"
  tenant_id       = "558506eb-9459-4ef3-b920-ad55c555e729" # "72f988bf-86f1-41af-91ab-2d7cd011db47"
  # client_id       = "a0d7fbe0-dca2-4848-b6ac-ad15e2c31840"
  # client_secret   = "BAFHTR3235FEHsdfb%#$W%weF#@a"
  # auxiliary_tenant_ids = ["558506eb-9459-4ef3-b920-ad55c555e729"]
  features {}
}

# Configure the Azure Active Directory Provider
provider "azuread" { # default takes current user/identity tenant
}

provider "azuread" {
  alias     = "tenant_hub"
  tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  # use_cli = true
}

provider "azuread" {
  alias     = "tenant_spoke"
  tenant_id = "558506eb-9459-4ef3-b920-ad55c555e729"
  # use_cli = true
}

provider "azapi" {
  # Configuration options
}