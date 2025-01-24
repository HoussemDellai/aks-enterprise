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
  data_collection_rule_id        = azurerm_monitor_data_collection_rule.dcr-log-analytics.id
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
  data_collection_rule_id        = azurerm_monitor_data_collection_rule.dcr-log-analytics.id
  kubernetes_version             = "1.31.3"
  nodepools_user = {
    "poolapps01" = {
      vm_size = "Standard_D2s_v5"
      os_sku  = "Ubuntu"
    },
    # "poolappsarm" = {
    #   vm_size           = "Standard_D2pds_v6" # arm
    #   os_sku            = "Ubuntu"
    # },
  }
}
