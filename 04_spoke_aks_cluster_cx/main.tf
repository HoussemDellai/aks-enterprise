resource "azurerm_resource_group" "rg-dev" {
  name     = "rg-lzaks-spoke-aks-airbus-dev"
  location = "swedencentral"
}

resource "azurerm_resource_group" "rg-prod" {
  name     = "rg-lzaks-spoke-aks-airbus-prod"
  location = "swedencentral"
}

resource "azuread_group" "aks_admins" {
  display_name     = "aks-admins"
  security_enabled = true
  owners           = [data.azurerm_client_config.current.object_id]

  members = [
    data.azurerm_client_config.current.object_id
  ]
}

data "azurerm_client_config" "current" {}
# data "azuread_client_config" "current" {}

module "aks-dev" {
  source                         = "./modules/aks"
  location                       = azurerm_resource_group.rg-dev.location
  resource_group_name            = azurerm_resource_group.rg-dev.name
  resource_group_id              = azurerm_resource_group.rg-dev.id
  tenant_id                      = data.azurerm_client_config.current.tenant_id
  acr_id                         = data.terraform_remote_state.spoke_aks.outputs.acr.id
  log_analytics_workspace_id     = data.terraform_remote_state.management.outputs.log_analytics_workspace.id
  private_dns_zone_aks_id        = data.terraform_remote_state.hub.outputs.dns_zone_aks.id
  vnet_aks_id                    = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.id
  snet_aks_id                    = data.terraform_remote_state.spoke_aks.outputs.snet_aks.id
  eid_group_aks_admins_object_id = azuread_group.aks_admins.object_id
  kubernetes_version             = "1.31.3"
  nodepools_user = {
    "poolappsamd" = {
      vm_size = "Standard_D2s_v5"
      os_sku  = "Ubuntu"
    },
    # "poolappsarm" = {
    #   vm_size           = "Standard_D2pds_v5" # arm
    #   os_sku            = "Ubuntu"
    # },
  }
}

module "aks-prod" {
  source                         = "./modules/aks"
  location                       = azurerm_resource_group.rg-prod.location
  resource_group_name            = azurerm_resource_group.rg-prod.name
  resource_group_id              = azurerm_resource_group.rg-prod.id
  tenant_id                      = data.azurerm_client_config.current.tenant_id
  acr_id                         = data.terraform_remote_state.spoke_aks.outputs.acr.id
  log_analytics_workspace_id     = data.terraform_remote_state.management.outputs.log_analytics_workspace.id
  private_dns_zone_aks_id        = data.terraform_remote_state.hub.outputs.dns_zone_aks.id
  vnet_aks_id                    = data.terraform_remote_state.spoke_aks.outputs.vnet_spoke_aks.id
  snet_aks_id                    = data.terraform_remote_state.spoke_aks.outputs.snet_aks.id
  eid_group_aks_admins_object_id = azuread_group.aks_admins.object_id
  kubernetes_version             = "1.31.3"
  nodepools_user = {
    "poolappsamd" = {
      vm_size = "Standard_D2s_v5"
      os_sku  = "Ubuntu"
    },
    # "poolappsarm" = {
    #   vm_size           = "Standard_D2pds_v5" # arm
    #   os_sku            = "Ubuntu"
    # },
  }
}
