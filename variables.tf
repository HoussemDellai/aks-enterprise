# variable "prefix" {
#   type        = string
#   description = "A prefix used for all resources in this example"
# }

variable "rg_hub" {
  default     = "rg-hub"
  description = "Name of the Hub resource group Firewall, Hub VNET, Log Analytics."
}

variable "rg_spoke" {
  default     = "rg-spoke"
  description = "Name of the Spoke resource group for ACR, KV, Log Analytics."
}

variable "rg_aks" {
  default     = "rg-aks-cluster"
  description = "Name of the resource group."
}

variable "rg_aks_nodes" {
  default = "rg-aks-cluster-managed"
}

variable "resources_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "vnet_spoke" {
  description = "Virtual network Spoke name"
  default     = "vnet-spoke-aks"
}

variable "cidr_vnet_hub" {
  description = "HUB VNET address prefix"
  default     = "172.16.0.0/16"
}

variable "cidr_vnet_spoke" {
  description = "VNET Spoke address prefix"
  default     = "10.0.0.0/8"
}

variable "subnet_nodes" {
  description = "Subnet Name."
  default     = "subnet-aks-nodes"
}

variable "subnet_pods_name" {
  description = "Subnet Name."
  default     = "subnet-aks-pods"
}

variable "app_gateway_subnet_name" {
  description = "Subnet Name."
  default     = "subnet-appgw"
}

variable "apiserver_subnet_name" {
  description = "AKS API Server subnet name."
  default     = "subnet-apiserver"
}

variable "pe_subnet_name" {
  description = "Subnet for Private Endoints."
  default     = "subnet-pe"
}

variable "cidr_subnet_nodes" {
  description = "Subnet address prefix."
  default     = ["10.240.0.0/16"]
}

variable "cidr_subnet_pods" {
  description = "Subnet address prefix."
  default     = ["10.241.0.0/16"]
}

variable "cidr_subnet_appgateway" {
  description = "Subnet server IP address."
  default     = ["10.1.0.0/16"]
}

variable "apiserver_subnet_address_prefix" {
  description = "AKS API Server IP address."
  default     = ["10.2.0.0/28"]
}

variable "cidr_subnet_pe" {
  description = "Private Endpoints IP addresses."
  default     = ["10.3.0.0/28"]
}

variable "cidr_subnet_firewall" {
  description = "CIDR for Firewall Subnet."
  default     = ["172.16.1.0/26"]
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  default     = "appgw-aks"
}

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU"
  default     = "Standard_v2"
}

variable "app_gateway_tier" {
  description = "Tier of the Application Gateway tier"
  default     = "Standard_v2"
}

variable "acr_name" {
  description = "Name of ACR container registry"
}

variable "aks_name" {
  description = "AKS cluster name"
  default     = "aks-cluster"
}

variable "aks_dns_prefix" {
  description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
  default     = "aks"
}

variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 40
}

variable "aks_agent_vm_size" {
  description = "VM size"
  default     = "Standard_D2ds_v5"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.23.5"
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

variable "keyvault_name" {
  description = "Key Vault instance name"
  default     = "kvforaks011"
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

variable "enable_container_insights" {
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

variable "aks_enable_rbac" {
  description = "Enable RBAC on the AKS cluster. Defaults to true."
  default     = "true"
}

variable "enable_private_acr" {
  description = "Creates private ACR with Private DNS Zone and Private Endpoint."
  default     = "true"
}

variable "enable_private_keyvault" {
  description = "Creates private Keyvault with Private DNS Zone and Private Endpoint."
  default     = "true"
}

variable "log_analytics_workspace" {
  type        = string
  description = "Name of Log Analytics Workspace"
}

variable "aks_outbound_type" {
  type        = string
  description = "userAssignedNATGateway, loadBalancer, userDefinedRouting, managedNATGateway"
}

variable "enable_keyvault" {
  type        = bool
  description = "Creates a Keyvault."
}

# variable "enable_velero_backups" {
#   type        = bool
#   description = "Enable installing Velero and creating backups for AKS"
# }

# variable "storage_account_name_backup" {
#   type        = string
#   description = "Name of Storage Account for Backup"
# }

# variable "backups_rg_name" {
#   type        = string
#   description = "Name of Resource Group for AKS backups"
# }

# variable "backups_region" {
#   type        = string
#   description = "Region for AKS backups"
# }

# variable "velero_values" {
#   description = <<EOVV
# Settings for Velero helm chart:
# ```
# map(object({
#   configuration.backupStorageLocation.bucket                = string 
#   configuration.backupStorageLocation.config.resourceGroup  = string 
#   configuration.backupStorageLocation.config.storageAccount = string 
#   configuration.backupStorageLocation.name                  = string 
#   configuration.provider                                    = string 
#   configuration.volumeSnapshotLocation.config.resourceGroup = string 
#   configuration.volumeSnapshotLocation.name                 = string 
#   credential.exstingSecret                                  = string 
#   credentials.useSecret                                     = string 
#   deployRestic                                              = string 
#   env.AZURE_CREDENTIALS_FILE                                = string 
#   metrics.enabled                                           = string 
#   rbac.create                                               = string 
#   schedules.daily.schedule                                  = string 
#   schedules.daily.template.includedNamespaces               = string 
#   schedules.daily.template.snapshotVolumes                  = string 
#   schedules.daily.template.ttl                              = string 
#   serviceAccount.server.create                              = string 
#   snapshotsEnabled                                          = string 
#   initContainers[0].name                                    = string 
#   initContainers[0].image                                   = string 
#   initContainers[0].volumeMounts[0].mountPath               = string 
#   initContainers[0].volumeMounts[0].name                    = string 
#   image.repository                                          = string 
#   image.tag                                                 = string 
#   image.pullPolicy                                          = string 
#   podAnnotations.aadpodidbinding                            = string
#   podLabels.aadpodidbinding                                 = string
# }))
# ```
# EOVV
#   type        = map(string)
#   default     = {}
# }

# variable "harbor_admin_password" {
#   type        = string
#   description = "Password for Harbor"
#   default     = "@Aa123456789"
# }

# variable "grafana_admin_user" {
#   type        = string
#   description = "Admin user for Grafana"
#   default     = "grafana"
# }

# variable "grafana_admin_password" {
#   type        = string
#   description = "Password for Grafana"
#   default     = "@Aa123456789"
# }

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
  }
}