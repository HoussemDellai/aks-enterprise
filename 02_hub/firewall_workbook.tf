data "http" "firewall_workbook" {
  url = "https://raw.githubusercontent.com/Azure/Azure-Network-Security/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook/Azure%20Firewall_Gallery.json"
}

resource "azurerm_application_insights_workbook" "workbook" {
  provider            = azurerm.subscription_hub
  name                = "85b3e8bb-fc93-40be-83f2-98f6bec18ba0" # "firewall-monitor-workbook"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  display_name        = "Azure Firewall Monitor Workbook"
  data_json           = data.http.firewall_workbook.response_body
  tags                = var.tags
}

resource "null_resource" "firewall_monitor_workbook" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az deployment group create -g ${azurerm_resource_group.rg.name} -n firewall-workbook --template-uri "https://raw.githubusercontent.com/Azure/Azure-Network-Security/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook/Azure%20Firewall_ResourceSpecific_ARM.json"
    EOT
  }
}

# https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Network-Security%2Fmaster%2FAzure%2520Firewall%2FWorkbook%2520-%2520Azure%2520Firewall%2520Monitor%2520Workbook%2FAzure%2520Firewall_ARM.json
