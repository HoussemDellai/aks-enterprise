variable "prefix" {
  type        = string
  description = "A prefix used for all resources"
}

variable "resources_location" {
  description = "Location of the resource group."
}

# variable "log_analytics_workspace" {
#   description = "Name of the Log Analytics Workspace."
# }

variable "subscription_id_onprem" {
  description = "Subscription ID for onprem"
}

variable "tenant_id_onprem" {
  description = "Azure AD tenant ID for onprem"
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
    architecture : "Hub&Spoke"
  }
}
