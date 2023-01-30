resource "azurerm_resource_group" "rg_hub" {
  provider = azurerm.subscription_hub
  name     = var.rg_hub
  location = var.resources_location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_spoke_app" {
  name     = var.rg_spoke_app
  location = var.resources_location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_spoke_mgt" {
  count    = var.enable_vm_jumpbox_windows || var.enable_vm_jumpbox_linux ? 1 : 0
  name     = var.rg_spoke_mgt
  location = var.resources_location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_spoke_aks" {
  name     = var.rg_spoke_aks
  location = var.resources_location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_network_watcher" {
  count    = var.enable_nsg_flow_logs ? 1 : 0
  name     = "NetworkWatcherRG"
  location = var.resources_location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg_spoke_shared" {
  name     = var.rg_spoke_shared
  location = var.resources_location
  tags     = var.tags
}