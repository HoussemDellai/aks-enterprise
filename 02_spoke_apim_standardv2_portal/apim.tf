data "azapi_resource" "apim" {
  type                      = "Microsoft.ApiManagement/service@2024-06-01-preview"
  name                      = "apim-standardv2-weu"
  parent_id                 = azurerm_resource_group.rg.id

  response_export_values = ["*"]
}

# data "azurerm_api_management" "apim" {
#   name                          = "apim-standardv2-weu"
#   resource_group_name           = azurerm_resource_group.rg.name
# }

# # Terraform azurerm provider doesn't support yet creating API Management instances with stv2 SKU.
# resource "azapi_resource" "apim" {
#   type                      = "Microsoft.ApiManagement/service@2024-06-01-preview"
#   name                      = "apim-genai-standardv2-${var.prefix}"
#   parent_id                 = azurerm_resource_group.rg.id
#   location                  = azurerm_resource_group.rg.location
#   schema_validation_enabled = true

#   identity {
#     type = "SystemAssigned"
#   }

#   body = {
#     sku = {
#       name     = "StandardV2"
#       capacity = 1
#     }
#     properties = {
#       publisherEmail      = "noreply@microsoft.com"
#       publisherName       = "My Company"
#       virtualNetworkType  = "External"
#       publicNetworkAccess = "Enabled"
#       publicIpAddressId   = azurerm_public_ip.pip-apim.id
      
#       virtualNetworkConfiguration = {
#         subnetResourceId = azurerm_subnet.snet-apim.id
#       }
#     }
#   }

#   response_export_values = ["*"]
# }

# # resource "azurerm_api_management" "apim" {
# #   name                          = "apim-genai-${var.prefix}"
# #   location                      = azurerm_resource_group.rg.location
# #   resource_group_name           = azurerm_resource_group.rg.name
# #   publisher_name                = "My Company"
# #   publisher_email               = "noreply@microsoft.com"
# #   sku_name                      = "Consumption_0" # "Developer_1"
# #   virtual_network_type          = "None"          # None, External, Internal
# #   public_network_access_enabled = true            # false applies only when using private endpoint as the exclusive access method

# #   identity {
# #     type = "SystemAssigned"
# #   }
# # }

resource "azurerm_role_assignment" "Cognitive-Services-OpenAI-User" {
  scope                = azurerm_ai_services.ai-services.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = data.azapi_resource.apim.identity.0.principal_id # data.azurerm_api_management.apim.identity.0.principal_id # 
}
