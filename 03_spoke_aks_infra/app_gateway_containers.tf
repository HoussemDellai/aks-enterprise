# {
#     "properties": {
#         "configurationEndpoints": [
#             "08d2f9f706b94c25a227ded982519675.alb.azure.com"
#         ],
#         "frontends": [
#             {
#                 "id": "/subscriptions/82f6d75e-85f4-434a-ab74-5dddd9fa8910/resourceGroups/rg-aks-agwfc/providers/Microsoft.ServiceNetworking/trafficControllers/agwc-alb/frontends/frontend-app"
#             }
#         ],
#         "associations": [],
#         "provisioningState": "Succeeded"
#     },
#     "id": "/subscriptions/82f6d75e-85f4-434a-ab74-5dddd9fa8910/resourceGroups/rg-aks-agwfc/providers/Microsoft.ServiceNetworking/trafficControllers/agwc-alb",
#     "name": "agwc-alb",
#     "type": "Microsoft.ServiceNetworking/TrafficControllers",
#     "etag": "49e99d39-4291-4e0e-88e0-363415c7d8bf",
#     "location": "westeurope"
# }

# {
#     "type": "Microsoft.ServiceNetworking/trafficControllers/associations",
#     "apiVersion": "2023-05-01-preview",
#     "name": "[concat(parameters('trafficControllers_agwc_alb_name'), '/association-app')]",
#     "location": "westeurope",
#     "dependsOn": [
#         "[resourceId('Microsoft.ServiceNetworking/trafficControllers', parameters('trafficControllers_agwc_alb_name'))]"
#     ],
#     "properties": {
#         "associationType": "subnets",
#         "subnet": {
#             "id": "[concat(parameters('virtualNetworks_aks_vnet_63478329_externalid'), '/subnets/subnet-alb')]"
#         }
#     }
# },
# {
#     "type": "Microsoft.ServiceNetworking/trafficControllers/frontends",
#     "apiVersion": "2023-05-01-preview",
#     "name": "[concat(parameters('trafficControllers_agwc_alb_name'), '/frontend-app')]",
#     "location": "westeurope",
#     "dependsOn": [
#         "[resourceId('Microsoft.ServiceNetworking/trafficControllers', parameters('trafficControllers_agwc_alb_name'))]"
#     ],
#     "properties": {}
# }

resource "azapi_resource" "agc" {
  count     = var.enable_appgateway_containers ? 1 : 0
  type      = "Microsoft.ServiceNetworking/TrafficControllers@2023-05-01-preview"
  name      = "app-gateway-containers"
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location

  #   body = jsonencode({
  #     properties = {
  #       frontends = []
  #       associations = []
  #     }
  #   })
  #   response_export_values = ["id"]
}

resource "azapi_resource" "agc_frontend" {
  count     = var.enable_appgateway_containers ? 1 : 0
  type      = "Microsoft.ServiceNetworking/TrafficControllers/frontends@2023-05-01-preview"
  name      = "frontend-app"
  parent_id = azapi_resource.agc.0.id
  location  = azurerm_resource_group.rg.location

  #   body = jsonencode({
  #     properties = {
  #       frontends = []
  #       associations = []
  #     }
  #   })
}

resource "azapi_resource" "agc_association" {
  count     = var.enable_appgateway_containers ? 1 : 0
  type      = "Microsoft.ServiceNetworking/TrafficControllers/associations@2023-05-01-preview"
  name      = "association-app"
  parent_id = azapi_resource.agc.0.id
  location  = azurerm_resource_group.rg.location

  body = jsonencode({
    properties = {
      associationType = "subnets"
      subnet = {
        id = azurerm_subnet.subnet_agc.0.id
      }
    }
  })
}
