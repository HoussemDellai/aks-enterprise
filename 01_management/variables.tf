variable "prefix" {
  type        = string
  description = "A prefix used for all resources"
}

variable "resources_location" {
  description = "Location of the resource group."
}

variable "log_analytics_workspace" {
  description = "Name of the Log Analytics Workspace."
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
