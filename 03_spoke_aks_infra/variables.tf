variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "location" {
  description = "Location of the resource group."
}

variable "cidr_snet_aks" {
  description = "Subnet AKS address prefix"
}

variable "cidr_vnet_spoke_aks" {
  description = "VNET Spoke address prefix"
}

variable "cidr_snet_app_gateway" {
  description = "Subnet server IP address."
}

variable "cidr_snet_pe" {
  description = "Private Endpoints IP addresses."
  default     = ["10.3.0.0/28"]
}

variable "cidr_snet_agc" {
}

variable "keyvault_name" {
  description = "Key Vault instance name"
  default     = "kvforaks011"
}

variable "acr_name" {
  description = "ACR instance name"
}

variable "storage_account_name" {
  description = "Storage Account name"
}

variable "enable_app_gateway" {
  type        = bool
  description = "Enable AGIC addon for AKS"
}

variable "enable_keyvault" {
  type        = bool
  description = "Creates a Keyvault."
}

variable "enable_private_acr" {
  description = "Creates private ACR with Private DNS Zone and Private Endpoint."
  default     = "true"
}

variable "enable_private_keyvault" {
  description = "Creates private Keyvault with Private DNS Zone and Private Endpoint."
  default     = "true"
}

variable "enable_storage_account" {
  type        = bool
  description = "Creates Storage Account"
}

variable "enable_grafana_prometheus" {
  type = bool
}

variable "enable_route_traffic_to_firewall" {
  type = bool
  # validation { # The condition for variable "enable_route_traffic_to_firewall" can only refer to the variable itself
  #   condition = (var.enable_route_traffic_to_firewall == true && var.enable_hub_spoke == true) || (var.enable_route_traffic_to_firewall == false && var.enable_hub_spoke == false)
  #   error_message = "You can't enable route traffic to firewall if firewall is not enabled"
  # }
}

variable "enable_firewall_as_dns_server" {
  type = bool
}

variable "enable_appgateway_containers" {
  type = bool
}

# variable "enable_vnet_peering" {
#   type = bool
# }

variable "subscription_id_hub" {
  description = "Subscription ID for Hub"
}

variable "subscription_id_spoke" {
  description = "Subscription ID for Spoke"
}

variable "tenant_id_hub" {
  description = "Azure AD tenant ID for Hub"
}

variable "tenant_id_spoke" {
  description = "Azure AD tenant ID for Spoke"
}

variable "enable_hub_spoke" {
  description = "Enable Hub & Spoke"
  type        = bool
  default     = false
}

# variable "cidr_subnet_apiserver_vnetint" {
#   description = "CIDR block for the API server subnet"
#   type        = string
# }

# variable "enable_apiserver_vnet_integration" {
#   description = "Enable API server VNet integration"
#   type        = bool
#   default     = false
# }

variable "tags" {
  type = map(string)

  default = {
    source       = "terraform"
    environment  = "development"
    architecture = "Hub&Spoke"
  }
}
