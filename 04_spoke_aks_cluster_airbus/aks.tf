resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "aks-cluster-airbus"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = "aks"
  kubernetes_version      = "1.31.3"
  private_cluster_enabled = false

  network_profile {
    network_plugin      = "azure" # var.aks_network_plugin # "kubenet", "azure", "none"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium" # azure and cilium
    network_policy      = "cilium"
    outbound_type       = "userDefinedRouting"
  }

  default_node_pool {
    name                 = "systemnp"
    vm_size              = "Standard_D2s_v5"
    os_sku               = "AzureLinux" # Ubuntu
    auto_scaling_enabled = true
    node_count           = 2
    min_count            = 1
    max_count            = 3
    max_pods             = 110
    vnet_subnet_id       = var.snet_aks_id
    os_disk_type         = "Managed" # "Ephemeral" # 
    ultra_ssd_enabled    = false
  }

  identity {
    type = "SystemAssigned"
  }

  web_app_routing {
    dns_zone_ids = []
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.upgrade_settings
    ]
  }
}

# Required to create internal Load Balancer
resource "azurerm_role_assignment" "network-contributor" {
  scope                = var.snet_aks_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}

resource "terraform_data" "aks-get-credentials" {
  triggers_replace = [
    azurerm_kubernetes_cluster.aks.id
  ]

  provisioner "local-exec" {
    command = "az aks get-credentials -n ${azurerm_kubernetes_cluster.aks.name} -g ${azurerm_kubernetes_cluster.aks.resource_group_name} --overwrite-existing"
  }
}
