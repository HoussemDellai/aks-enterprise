variable "location" {
  description = "Location of the resource group."
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "resource_group_id" {
  description = "Resource Group ID"
}

variable "snet_aks_id" {
  description = "Subnet AKS ID"
}

variable "vnet_aks_id" {
  description = "VNET AKS ID"
}

variable "private_dns_zone_aks_id" {
  description = "Private DNS Zone AKS ID"
}

variable "acr_id" {
  description = "ACR ID"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
}

variable "tenant_id" {
  description = "Tenant ID"
}

variable "eid_group_aks_admins_object_id" {
  description = "Enterprise ID Group AKS Admins Object ID"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
}

variable "data_collection_rule_id" {
  description = "Data Collection Rule ID"
}

variable "nodepools_user" {
  type = map(object({
    vm_size = string
    os_sku  = string
  }))
}

variable "tags" {
  type = map(string)

  default = {
    source       = "terraform"
    environment  = "development"
    architecture = "Hub&Spoke"
  }
}
