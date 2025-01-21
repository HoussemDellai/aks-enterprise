resource "azurerm_resource_group" "rg" {
  location = "swedencentral"
  name     = "rg-lzaks-spoke-aks-airbus-dev"
}

data "azurerm_client_config" "current" {}

module "aks" {
  source                     = "./modules/aks"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  resource_group_id          = azurerm_resource_group.rg.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  acr_id                     = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourceGroups/rg-lzaks-spoke-aks-infra/providers/Microsoft.ContainerRegistry/registries/acrforakstf01357"
  log_analytics_workspace_id = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourceGroups/rg-lzaks-management/providers/Microsoft.OperationalInsights/workspaces/loganalyticsforaks011"
  private_dns_zone_aks_id    = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourceGroups/rg-lzaks-hub/providers/Microsoft.Network/privateDnsZones/privatelink.swedencentral.azmk8s.io"
  vnet_aks_id                = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourceGroups/rg-lzaks-spoke-aks-infra/providers/Microsoft.Network/virtualNetworks/vnet-spoke-aks"
  snet_aks_id                = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourceGroups/rg-lzaks-spoke-aks-infra/providers/Microsoft.Network/virtualNetworks/vnet-spoke-aks/subnets/snet-aks-airbus"
}
