locals {
  resource_types = toset([
    "Microsoft.Network/networkSecurityGroups",
    "Microsoft.Network/virtualNetworks",
    "Microsoft.Network/applicationGateways",
    "Microsoft.Network/bastionHosts",
    "Microsoft.Network/networkInterfaces",
    "Microsoft.Compute/virtualMachines",
    "Microsoft.KeyVault/vaults",
    "Microsoft.Network/azureFirewalls",
    "Microsoft.Storage/storageAccounts",
    "Microsoft.ContainerRegistry/registries",
    "Microsoft.ContainerService/managedClusters",
    "Microsoft.Network/publicIPAddresses",
    "Microsoft.OperationalInsights/workspaces",
    "Microsoft.Network/loadBalancers",
    "Microsoft.Network/expressRouteCircuits",
    "Microsoft.Network/expressRouteGateways",
    "Microsoft.Network/expressRoutePorts"
  ])
}

data "azurerm_resources" "resources_ds" {
  for_each      = local.resource_types
  type          = each.key
  required_tags = var.tags
}

locals {
  resource_ids = toset(flatten([for r in data.azurerm_resources.resources_ds : [r.resources.*.id]]))
}

module "diagnostic_setting" {
  for_each                   = local.resource_ids
  source                     = "../modules/diagnostic_setting"
  target_resource_id         = each.key
  log_analytics_workspace_id = data.terraform_remote_state.management.outputs.log_analytics_workspace.id
}

output "resources_id" {
  value = local.resource_ids
}