variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "resources_location" {
  description = "Location of the resource group."
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

variable "enable_nsg_flow_logs" {
  type = bool
}

variable "enable_monitoring" {
  type = bool
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
    architecture : "Hub&Spoke"
  }
}