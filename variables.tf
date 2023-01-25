# variable "prefix" {
#   type        = string
#   description = "A prefix used for all resources in this example"
# }

variable "rg_hub" {
  default     = "rg-hub"
  description = "Name of the Hub resource group Firewall, Hub VNET, Log Analytics."
}

variable "rg_spoke_app" {
  default     = "rg-spoke-app"
  description = "Name of the Spoke resource group for ACR, KV, Log Analytics."
}

variable "rg_spoke_mgt" {
  default     = "rg-spoke-vm"
  description = "Name of the Spoke resource group for Jumpbox VM."
}

variable "rg_spoke_aks" {
  default     = "rg-spoke-aks"
  description = "Name of the resource group."
}

variable "rg_spoke_aks_nodes" {
}

variable "resources_location" {
  description = "Location of the resource group."
}

variable "cidr_vnet_hub" {
  description = "HUB VNET address prefix"
}

variable "cidr_vnet_spoke_app" {
  description = "VNET Spoke address prefix"
}

variable "cidr_vnet_spoke_3" {
  description = "VNET Spoke 3 address prefix"
}

variable "cidr_vnet_spoke_mgt" {
  description = "CIDR for Management/Jumpbox VM VNET."
}

variable "cidr_vnet_spoke_shared" {
  description = "VNET Spoke Shared resources address prefix"
}

variable "cidr_subnet_shared" {
  description = "Shared subnet for shared sresources."
}

variable "cidr_subnet_nodes" {
  description = "Subnet address prefix."
}

variable "cidr_subnet_pods" {
  description = "Subnet address prefix."
}

variable "cidr_subnet_appgateway" {
  description = "Subnet server IP address."
}

variable "cidr_subnet_apiserver_vnetint" {
  description = "AKS API Server IP address."
}

variable "cidr_subnet_pe" {
  description = "Private Endpoints IP addresses."
  default     = ["10.3.0.0/28"]
}

variable "cidr_subnet_bastion" {
  description = "CIDR range for Subnet Bastion"
}

variable "cidr_subnet_firewall" {
  description = "CIDR for Firewall Subnet."
}

variable "cidr_subnet_mgt" {
  description = "CIDR for Management/Jumpbox VM Subnet."
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

variable "cidr_aks_docker_bridge" {
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}

variable "vm_user_name" {
  description = "User name for the VM"
  default     = "vmuser1"
}

variable "public_ssh_key_path" {
  description = "Public key path for SSH."
  default     = "~/.ssh/id_rsa.pub"
}

variable "aks_name" {
  description = "AKS instance name"
  default     = "aks-cluster"
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

# variable "aks_admin_group_object_ids" {
#   description = "Azure AD admin group for AKS."
# }

variable "aks_network_plugin" {
  type        = string
  description = "AKS network Plugin (Azure CNI or Kubenet)"
}

variable "aad_group_aks_admins" {
  type        = string
  description = "Name of AAD group for AKS admins"
}

variable "enable_aks_cluster" {
  type        = bool
  description = "Enable AKS"
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
  description = "Enable cluster monitoring using Azure Container Insights"
}

variable "enable_nodepool_apps" {
  type        = bool
  description = "Creates Apps Nodepool"
}

variable "enable_nodepool_spot" {
  type        = bool
  description = "Creates Spot Nodepool"
}

variable "enable_vnet_peering" {
  type        = bool
  description = "Enable VNET peering between AKS VNET and Jumpbox VNET"
}

variable "enable_aks_admin_group" {
  type        = bool
  description = "Creates Azure AD admin group for AKS"
}

variable "enable_aks_admin_rbac" {
  type        = bool
  description = "Adds admin role for AKS"
}

variable "enable_keyvault" {
  type        = bool
  description = "Creates a Keyvault."
}

variable "enable_bastion" {
  type        = bool
  description = "Creates a Bastion Host."
}

variable "enable_firewall" {
  type        = bool
  description = "Creates an Azure Firewall."
}

variable "enable_private_acr" {
  description = "Creates private ACR with Private DNS Zone and Private Endpoint."
  default     = "true"
}

variable "enable_private_keyvault" {
  description = "Creates private Keyvault with Private DNS Zone and Private Endpoint."
  default     = "true"
}

variable "enable_vm_jumpbox_windows" {
  description = "Creates Azure Windows VM."
  default     = "true"
}

variable "enable_vm_jumpbox_linux" {
  description = "Creates Azure Linux VM."
  default     = "true"
}

variable "enable_nsg_flow_logs" {
  description = "Enables NSG flow logs"
  default     = "true"
}

variable "enable_spoke_3" {
  type        = bool
  description = "Creates Spoke 3"
}

variable "enable_storage_account" {
  type        = bool
  description = "Creates Storage Account"
}

variable "enable_fleet_manager" {
  type        = bool
  description = "Creates AKS Fleet Manager reosurce"
}

variable "log_analytics_workspace" {
  type        = string
  description = "Name of Log Analytics Workspace"
}

variable "aks_outbound_type" {
  type        = string
  description = "userAssignedNATGateway, loadBalancer, userDefinedRouting, managedNATGateway"
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
