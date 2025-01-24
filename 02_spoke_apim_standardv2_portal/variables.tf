variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "location" {
  description = "Location of the resource group."
}

variable "enable_route_traffic_to_firewall" {
  type = bool
}

variable "enable_firewall_as_dns_server" {
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
}

variable "tags" {
  type = map(string)

  default = {
    source       = "terraform"
    environment  = "development"
    architecture = "Hub&Spoke"
  }
}
