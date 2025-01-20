# variable prefix {
#   type        = string
#   description = "A prefix used for all resources in this example"
# }

variable "resource_group_name" {
  default     = "rg-aks-cluster"
  description = "Name of the resource group."
}

# variable node_resource_group {
#   default = "rg-aks-cluster-managed"
# }

# variable location {
#   default     = "westeurope"
#   description = "Location of the resource group."
# }

# variable virtual_network_name {
#   description = "Virtual network name"
#   default     = "vnet-spoke-aks"
# }

# variable virtual_network_address_prefix {
#   description = "VNET address prefix"
#   default     = "10.0.0.0/8"
# }

# variable subnet_nodes_name {
#   description = "Subnet Name."
#   default     = "subnet-aks-nodes"
# }

# variable subnet_pods {
#   description = "Subnet Name."
#   default     = "subnet-aks-pods"
# }

# variable subnet_app_gateway {
#   description = "Subnet Name."
#   default     = "subnet-appgw"
# }

# variable cidr_subnet_nodes {
#   description = "Subnet address prefix."
#   default     = ["10.240.0.0/16"]
# }

# variable cidr_subnet_pods {
#   description = "Subnet address prefix."
#   default     = ["10.241.0.0/16"]
# }

# variable cidr_subnet_appgateway {
#   description = "Subnet server IP address."
#   default     = ["10.1.0.0/16"]
# }

# variable app_gateway {
#   description = "Name of the Application Gateway"
#   default     = "appgw-aks"
# }

# variable app_gateway_sku {
#   description = "Name of the Application Gateway SKU"
#   default     = "Standard_v2"
# }

# variable acr_name {
#   description = "Name of ACR container registry"
# }

variable "aks_name" {
  description = "AKS cluster name"
  default     = "aks-cluster"
}

# variable aks_dns_prefix {
#   description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
#   default     = "aks"
# }

# variable aks_agent_os_disk_size {
#   description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
#   default     = 40
# }

# variable aks_agent_count {
#   description = "The number of agent nodes for the cluster."
#   default     = 1
# }

# variable kubernetes_version {
#   description = "Kubernetes version"
#   default     = "1.23.5"
# }

# variable cidr_aks_service {
#   description = "CIDR notation IP range from which to assign service cluster IPs"
#   default     = "10.0.0.0/16"
# }

# variable aks_dns_service_ip {
#   description = "DNS server IP address"
#   default     = "10.0.0.10"
# }

# variable cidr_aks_docker_bridge {
#   description = "CIDR notation IP for Docker bridge."
#   default     = "172.17.0.1/16"
# }

# variable aks_enable_rbac {
#   description = "Enable RBAC on the AKS cluster. Defaults to true."
#   default     = "true"
# }

# variable vm_user_name {
#   description = "User name for the VM"
#   default     = "vmuser1"
# }

# variable public_ssh_key_path {
#   description = "Public key path for SSH."
#   default     = "~/.ssh/id_rsa.pub"
# }

# variable keyvault_name {
#   description = "Key Vault instance name"
#   default     = "kvforaks011"
# }

# variable aks_admin_group_object_ids {
#   description = "Azure AD admin group for AKS."
# }

# variable aks_network_plugin {
#   type        = string
#   description = "AKS network Plugin (Azure CNI or Kubenet)"
# }

# variable spn_name {
#   type        = string
#   description = "Name of Service Principal"
# }

variable "aad_group_aks_admins" {
  type        = string
  description = "Name of AAD group for AKS admins"
}

# variable enable_velero_backups {
#   type        = bool
#   description = "Enable installing Velero and creating backups for AKS"
# }

variable "storage_account_name_backup" {
  type        = string
  description = "Name of Storage Account for Backup"
}

variable "backups_rg_name" {
  type        = string
  description = "Name of Resource Group for AKS backups"
}

variable "backups_region" {
  type        = string
  description = "Region for AKS backups"
}

variable "velero_values" {
  description = <<EOVV
Settings for Velero helm chart:
```
map(object({
  configuration.backupStorageLocation.bucket                = string 
  configuration.backupStorageLocation.config.resourceGroup  = string 
  configuration.backupStorageLocation.config.storageAccount = string 
  configuration.backupStorageLocation.name                  = string 
  configuration.provider                                    = string 
  configuration.volumeSnapshotLocation.config.resourceGroup = string 
  configuration.volumeSnapshotLocation.name                 = string 
  credential.exstingSecret                                  = string 
  credentials.useSecret                                     = string 
  deployRestic                                              = string 
  env.AZURE_CREDENTIALS_FILE                                = string 
  metrics.enabled                                           = string 
  rbac.create                                               = string 
  schedules.daily.schedule                                  = string 
  schedules.daily.template.includedNamespaces               = string 
  schedules.daily.template.snapshotVolumes                  = string 
  schedules.daily.template.ttl                              = string 
  serviceAccount.server.create                              = string 
  snapshotsEnabled                                          = string 
  initContainers[0].name                                    = string 
  initContainers[0].image                                   = string 
  initContainers[0].volumeMounts[0].mountPath               = string 
  initContainers[0].volumeMounts[0].name                    = string 
  image.repository                                          = string 
  image.tag                                                 = string 
  image.pullPolicy                                          = string 
  podAnnotations.aadpodidbinding                            = string
  podLabels.aadpodidbinding                                 = string
}))
```
EOVV
  type        = map(string)
  default     = {}
}

variable "harbor_admin_password" {
  type        = string
  description = "Password for Harbor"
}

variable "grafana_admin_user" {
  type        = string
  description = "Admin user for Grafana"
}

variable "grafana_admin_password" {
  type        = string
  description = "Password for Grafana"
}

variable "argocd_admin_password" {
  type        = string
  description = "Password for Argo CD, should be bcrypt"
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
  }
}