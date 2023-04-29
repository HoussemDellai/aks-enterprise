# deploy arm template

# https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Network-Security%2Fmaster%2FAzure%2520Firewall%2FWorkbook%2520-%2520Azure%2520Firewall%2520Monitor%2520Workbook%2FAzure%2520Firewall_ARM.json

# resource "azurerm_resource_group_template_deployment" "firewall_workbook" {
#   provider            = azurerm.subscription_hub
#   name                = "firewall-workbook"
#   resource_group_name = azurerm_resource_group.rg_hub.name
#   deployment_mode     = "Incremental"
#   # parameters_content = jsonencode({
#   #   "vnetName" = {
#   #     value = local.vnet_name
#   #   }
#   # })
#   template_content = templatefile("firewall_workbook/Azure Firewall_ARM.json", {})
# }

resource "null_resource" "firewall_monitor_workbook" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az deployment group create -g ${azurerm_resource_group.rg_hub.name} -n firewall-workbook --template-uri "https://raw.githubusercontent.com/Azure/Azure-Network-Security/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook/Azure%20Firewall_ResourceSpecific_ARM.json"
    EOT
  }
}

# https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Network-Security%2Fmaster%2FAzure%2520Firewall%2FWorkbook%2520-%2520Azure%2520Firewall%2520Monitor%2520Workbook%2FAzure%2520Firewall_ARM.json
