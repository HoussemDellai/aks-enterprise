resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resources_location
}

# Locals block for hardcoded names
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-rqrt"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  tags = var.tags
}

resource "azurerm_subnet" "kubesubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.aks_subnet_address_prefix

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "appgwsubnet" {
  name                 = var.app_gateway_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.app_gateway_subnet_address_prefix

  depends_on = [azurerm_virtual_network.vnet]
}

# Public Ip 
resource "azurerm_public_ip" "pip" {
  name                = "publicIp-appgw"
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.app_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  sku {
    name     = var.app_gateway_sku
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.appgwsubnet.id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_port {
    name = "httpsPort"
    port = 443
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  backend_address_pool {
    name = local.backend_address_pool_name
  }
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
  tags       = var.tags
  depends_on = [azurerm_virtual_network.vnet, azurerm_public_ip.pip]
}

resource "azurerm_user_assigned_identity" "identity-aks" {
  name                = "identity-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_mi_network_contributor" {
  scope                            = azurerm_virtual_network.vnet.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.identity-aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                              = var.aks_name
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = var.resources_location
  kubernetes_version                = var.kubernetes_version
  dns_prefix                        = var.aks_dns_prefix
  private_cluster_enabled           = false
  node_resource_group               = var.node_resource_group
  role_based_access_control_enabled = true
  sku_tier                          = "Free" # "Paid"
  linux_profile {
    admin_username = var.vm_user_name
    ssh_key {
      key_data = file(var.public_ssh_key_path)
    }
  }
  default_node_pool {
    name                         = "systempool"
    node_count                   = var.aks_agent_count
    vm_size                      = var.aks_agent_vm_size
    os_disk_size_gb              = var.aks_agent_os_disk_size
    vnet_subnet_id               = azurerm_subnet.kubesubnet.id
    only_critical_addons_enabled = true # taint default node pool with CriticalAddonsOnly=true:NoSchedule
  }
  identity {
    type                      = "UserAssigned" # "SystemAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.identity-aks.id
  }
  network_profile {
    network_plugin     = "azure"  # "kubenet" # 
    network_policy     = "calico" # "azure" 
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  }
  azure_active_directory_role_based_access_control {
    managed = true
    # admin_group_object_ids 
    azure_rbac_enabled = true
  }
  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.appgw.id
    # other options if we want to allow the AGIC addon to create a new AppGW 
    # and not use an existing one
    # subnet_id    = # link AppGW to specific Subnet
    # gateway_name = # give a name to the generated AppGW
    # subnet_cidr  = # specify the CIDR range for the Subnet that will be created
  }
  azure_policy_enabled      = true
  open_service_mesh_enabled = true

  tags       = var.tags
  depends_on = [azurerm_virtual_network.vnet, azurerm_application_gateway.appgw]
}

# AppGW (generated with addon) Identity needs also Contributor role over AKS/VNET RG
resource "azurerm_role_assignment" "role-contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.identity-appgw.principal_id
  depends_on           = [azurerm_kubernetes_cluster.aks, azurerm_application_gateway.appgw]
}

# generated managed identity for app gateway
data "azurerm_user_assigned_identity" "identity-appgw" {
  name                = "ingressapplicationgateway-${var.aks_name}" # convention name for AGIC Identity
  resource_group_name = var.node_resource_group
  depends_on          = [azurerm_kubernetes_cluster.aks]
}

resource "azurerm_kubernetes_cluster_node_pool" "appspool" {
  name                   = "appspool"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks.id
  vm_size                = "Standard_D2as_v5"
  node_count             = 1
  availability_zones     = ["1", "2", "3"]
  mode                   = "User"
  orchestrator_version   = var.kubernetes_version
  os_type                = "Linux"
  enable_host_encryption = false
  enable_node_public_ip  = false
  max_pods               = 110
  os_disk_size_gb        = 60
  os_disk_type           = "Managed" # "Ephemeral" # 
  enable_auto_scaling    = true
  min_count              = 1
  max_count              = 2
  # subnet_id = 
  # node_taints          = "CriticalAddonsOnly=true:NoSchedule"
  # node_labels = 
  upgrade_settings {
    max_surge = 1
  }
  tags = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  sku                 = "Standard"
  admin_enabled       = false # true
  tags                = var.tags
}

data "azurerm_client_config" "current" {
}

data "azurerm_user_assigned_identity" "identity-agentpool" {
  name                = "${azurerm_kubernetes_cluster.aks.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azurerm_user_assigned_identity.identity-agentpool.principal_id
  skip_service_principal_aad_check = true
}