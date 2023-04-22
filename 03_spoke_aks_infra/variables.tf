# variable prefix {
#   type        = string
#   description = "A prefix used for all resources in this example"
# }

variable "resources_location" {
  description = "Location of the resource group."
}

variable "cidr_vnet_spoke_aks" {
  description = "VNET Spoke address prefix"
}

variable "cidr_subnet_appgateway" {
  description = "Subnet server IP address."
}

variable "cidr_subnet_spoke_aks_pe" {
  description = "Private Endpoints IP addresses."
  default     = ["10.3.0.0/28"]
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

variable "enable_monitoring" {
  type = bool
}

variable "enable_firewall" {
  type = bool
}

variable "enable_vnet_peering" {
  type = bool
}

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

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
    architecture : "Hub&Spoke"
  }
}
