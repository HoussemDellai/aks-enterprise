# variable prefix {
#   type        = string
#   description = "A prefix used for all resources in this example"
# }

variable "resources_location" {
  description = "Location of the resource group."
}

variable "cidr_vnet_hub" {
  description = "HUB VNET address prefix"
}

variable "cidr_subnet_bastion" {
  description = "CIDR range for Subnet Bastion"
}

variable "cidr_subnet_firewall" {
  description = "CIDR for Firewall Subnet."
}

variable "enable_bastion" {
  type        = bool
  description = "Creates a Bastion Host."
}

variable "enable_firewall" {
  type        = bool
  description = "Creates an Azure Firewall."
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

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
    architecture : "Hub&Spoke"
  }
}
