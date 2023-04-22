# # reference to Azure Kubernetes Service AAD Server app in AAD
# data azuread_service_principal aks_aad_server {
#   display_name = "Azure Kubernetes Service AAD Server"
# }

data azurerm_client_config current {}

# data azurerm_subscription subscription_hub {
#   subscription_id = var.subscription_id_hub
# }

data azurerm_subscription subscription_spoke {
  subscription_id = var.subscription_id_spoke
}

# current client
data azuread_client_config current {}

data http machine_ip {
  url = "http://ifconfig.me"

  request_headers = {
    Accept = "application/json"
  }

  # lifecycle {
  #   postcondition {
  #     condition     = contains([201, 204], self.status_code)
  #     error_message = "Status code invalid"
  #   }
  # }
}