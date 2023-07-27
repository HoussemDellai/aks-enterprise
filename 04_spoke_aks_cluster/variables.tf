variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "resources_location" {
  description = "Location of the resource group."
}

variable "cidr_subnet_nodes" {
  description = "Subnet address prefix."
}

variable "cidr_subnet_pods" {
  description = "Subnet address prefix."
}

variable "cidr_subnet_apiserver_vnetint" {
  description = "AKS API Server IP address."
}

variable "cidr_subnet_spoke_aks_pe" {
  description = "Private Endpoints IP addresses."
  default     = ["10.3.0.0/28"]
}

variable "aks_dns_prefix" {
  description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
  default     = "aks"
}

variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 40
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.24.6"
}

variable "cidr_aks_service" {
  description = "CIDR notation IP range from which to assign service cluster IPs"
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS server IP address"
  default     = "10.0.0.10"
}

variable "vm_user_name" {
  description = "User name for the VM"
  default     = "vmuser1"
}

variable "public_ssh_key_path" {
  description = "Public key path for SSH."
  default     = "~/.ssh/id_rsa.pub"
}

variable "aks_network_plugin" {
  description = "Network plugin to use for networking. Defaults to azure for Windows and kubenet for Linux."
  default     = "azure"
}

variable "network_plugin_mode" {
  description = "Network plugin mode for Kubernetes."
  default     = "Overlay"
}

variable "aks_name" {
  description = "AKS instance name"
  default     = "aks-cluster"
}

# variable aks_admin_group_object_ids {
#   description = "Azure AD admin group for AKS."
# }

variable "aad_group_aks_admins" {
  type        = string
  description = "Name of AAD group for AKS admins"
}

variable "enable_apiserver_vnet_integration" {
  type        = bool
  description = "Enable AKS API Server VNET Integration"
}

variable "enable_app_gateway" {
  type        = bool
  description = "Enable AGIC addon for AKS"
}

variable "enable_private_cluster" {
  type        = bool
  description = "Enable private AKS cluster"
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable resources monitoring using Azure Log Analytics and Prometheus."
}

variable "enable_nodepool_apps" {
  type        = bool
  description = "Creates Apps Nodepool"
}

variable "enable_nodepool_spot" {
  type        = bool
  description = "Creates Spot Nodepool"
}

variable "enable_system_nodepool_only_critical_addons" {
  type        = bool
  description = "Enable system nodepool only for critical addons"
}

variable "enable_firewall_as_dns_server" {
  type = bool
}

variable "enable_aks_admin_group" {
  type        = bool
  description = "Creates Azure AD admin group for AKS"
}

variable "enable_aks_admin_rbac" {
  type        = bool
  description = "Adds admin role for AKS"
}

variable "enable_grafana_prometheus" {
  type = bool
}

variable "aks_outbound_type" {
  type        = string
  description = "userAssignedNATGateway, loadBalancer, userDefinedRouting, managedNATGateway"
}

variable "enable_maintenance_window" {
  type        = bool
  description = "Enable maintenance window for AKS"
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
