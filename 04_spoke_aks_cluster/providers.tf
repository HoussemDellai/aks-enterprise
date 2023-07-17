terraform {

  required_version = ">= 1.2.8"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.65.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.39.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "1.7.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  # alias           = "subscription_spoke" # default
  subscription_id = var.subscription_id_spoke
  tenant_id       = var.tenant_id_spoke
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
  subscription_id = var.subscription_id_hub
  tenant_id       = var.tenant_id_hub
  # client_id       = "a0d7fbe0-dca2-4848-b6ac-ad15e2c31840"
  # client_secret   = "BAFHTR3235FEHsdfb%#$W%weF#@a"
  # auxiliary_tenant_ids = ["558506eb-9459-4ef3-b920-ad55c555e729"]
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

# Configure the Azure Active Directory Provider
provider "azuread" { # default takes current user/identity tenant
}

# provider azuread {
#   alias     = "tenant_hub"
#   tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
#   # use_cli = true
# }

# provider azuread {
#   alias     = "tenant_spoke"
#   tenant_id = "558506eb-9459-4ef3-b920-ad55c555e729"
#   # use_cli = true
# }

provider "azapi" {
  # Configuration options
}
