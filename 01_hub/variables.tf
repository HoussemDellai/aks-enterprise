variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "location" {
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

variable "cidr_subnet_vm" {
  description = "CIDR for VM Subnet."
}

variable "cidr_subnet_firewall_mgmt" {
  description = "CIDR for Firewall Management Subnet."
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

variable "enable_vm_jumpbox_linux" {
  type        = bool
  description = "Creates a Linux VM Jumpbox."
}

variable "enable_vm_jumpbox_windows" {
  type        = bool
  description = "Creates a Windows VM Jumpbox."
}

variable "domain_name" {
  type = string
  validation {
    condition     = length(var.domain_name) > 0 && (endswith(var.domain_name, ".com") || endswith(var.domain_name, ".net") || endswith(var.domain_name, ".co.uk") || endswith(var.domain_name, ".org") || endswith(var.domain_name, ".nl") || endswith(var.domain_name, ".in") || endswith(var.domain_name, ".biz") || endswith(var.domain_name, ".org.uk") || endswith(var.domain_name, ".co.in"))
    error_message = "Available top level domains are: com, net, co.uk, org, nl, in, biz, org.uk, and co.in"
  }
}

variable "AgreedBy_IP_v6" { # "2a04:cec0:11d9:24c8:8898:3820:8631:d83"
  type = string
}

variable "AgreedAt_DateTime" { # "2023-08-10T11:50:59.264Z"
  type = string
}

variable "contact" {
  description = "Contact info for Domain Name Registration."
  type = object({
    nameFirst = string
    nameLast  = string
    email     = string
    phone     = string
    addressMailing = object({
      address1   = string
      city       = string
      state      = string
      country    = string
      postalCode = string
    })
  })
}

variable "enable_firewall_as_dns_server" {
  type = bool
}

variable "firewall_sku_tier" {
  type = string
  validation {
    condition     = var.firewall_sku_tier == "Standard" || var.firewall_sku_tier == "Premium" || var.firewall_sku_tier == "Basic"
    error_message = "Available tiers are: Standard, Premium, and Basic"
  }
}

variable "tags" {
  type = map(string)

  default = {
    source       = "terraform"
    environment  = "development"
    architecture = "Hub&Spoke"
  }
}
