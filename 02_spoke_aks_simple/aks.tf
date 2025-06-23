resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks-cluster"
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = azurerm_resource_group.rg.location
  kubernetes_version                  = "1.32.4"
  dns_prefix                          = "aks"
  sku_tier                            = "Free" # "Paid"
  private_cluster_enabled             = false
  private_cluster_public_fqdn_enabled = false
  role_based_access_control_enabled   = false
  azure_policy_enabled                = false
  open_service_mesh_enabled           = false
  local_account_disabled              = false
  run_command_enabled                 = false
  oidc_issuer_enabled                 = false
  workload_identity_enabled           = false
  http_application_routing_enabled    = false
  image_cleaner_enabled               = false
  cost_analysis_enabled               = false
  image_cleaner_interval_hours        = 24           # in the range (24 - 2160)
  private_dns_zone_id                 = null         # azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
  node_os_upgrade_channel             = "NodeImage"  # Unmanaged, SecurityPatch, NodeImage and None. Defaults to NodeImage
  automatic_upgrade_channel           = "node-image" # patch, rapid, node-image and stable. Omitting this field sets this value to none

  network_profile {
    network_plugin      = "azure" # var.aks_network_plugin # "kubenet", "azure", "none"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"       # azure and cilium
    network_policy      = "cilium"       # calico, azure and cilium
    outbound_type       = "loadBalancer" # "managedNATGateway" "userAssignedNATGateway" "loadBalancer" "none" "block"
    load_balancer_sku   = "standard"     # "basic"
    ip_versions         = ["IPv4"]       # ["IPv4", "IPv6"]
    pod_cidr            = "10.10.240.0/20"
    pod_cidrs           = ["10.10.240.0/20"]
    service_cidr        = "10.128.0.0/22"
    service_cidrs       = ["10.128.0.0/22"]
    dns_service_ip      = "10.128.0.10"
  }

  default_node_pool {
    name                         = "systempool"
    temporary_name_for_rotation  = "syspooltmp"
    vm_size                      = "Standard_D2ads_v6" # "Standard_D2s_v5" # "Standard_D2pds_v5" # "Standard_D2ds_v5" # "standard_d2pds_v5"
    auto_scaling_enabled         = true
    node_count                   = 2
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 110
    os_disk_size_gb              = 40
    os_disk_type                 = "Ephemeral" #"Managed" #
    ultra_ssd_enabled            = false
    os_sku                       = "Ubuntu"  # Ubuntu, AzureLinux, Windows2019, Windows2022
    only_critical_addons_enabled = false     # taint default node pool with CriticalAddonsOnly=true:NoSchedule
    zones                        = [1, 2, 3] # []
    vnet_subnet_id               = azurerm_subnet.snet_aks.id
    pod_subnet_id                = null     # azurerm_subnet.subnet_system_pods.id
    scale_down_mode              = "Delete" # "Deallocate"
    workload_runtime             = "OCIContainer"
    kubelet_disk_type            = "OS" # "Temporary" # 
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity_aks.id]
  }

  depends_on = [
    azurerm_subnet_route_table_association.association_rt_subnet_aks
  ]

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      default_node_pool.0.upgrade_settings
    ]
  }
}

/*
Note: This is a generated HCL content from the JSON input which is based on the latest API version available.
To import the resource, please run the following command:
terraform import azapi_resource.managedCluster /subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourcegroups/rg-spoke-aks-simple/providers/Microsoft.ContainerService/managedClusters/aks-cluster?api-version=2025-02-02-preview

Or add the below config:
import {
  id = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourcegroups/rg-spoke-aks-simple/providers/Microsoft.ContainerService/managedClusters/aks-cluster?api-version=2025-02-02-preview"
  to = azapi_resource.managedCluster
}
*/

resource "azapi_resource" "aks" {
  type      = "Microsoft.ContainerService/managedClusters@2025-02-02-preview"
  parent_id = azurerm_resource_group.rg.id
  name      = "aks-cluster-azapi"
  location  = azurerm_resource_group.rg.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity_aks.id]
  }

  body = {
    kind = "Base"
    properties = {
      agentPoolProfiles = [{
        availabilityZones      = ["2", "3", "1"]
        count                  = 2
        enableAutoScaling      = true
        enableEncryptionAtHost = false
        enableFIPS             = false
        enableNodePublicIP     = false
        enableUltraSSD         = false
        kubeletDiskType        = "OS"
        maxCount               = 3
        maxPods                = 110
        minCount               = 1
        mode                   = "System"
        name                   = "systempool"
        orchestratorVersion    = "1.32.4"
        osDiskSizeGB           = 40
        osDiskType             = "Ephemeral"
        osSKU                  = "Ubuntu"
        osType                 = "Linux"
        scaleDownMode          = "Delete"
        upgradeSettings = {
          maxSurge       = "10%"
          maxUnavailable = "0"
        }
        vmSize          = "Standard_D2ads_v5"
        vnetSubnetID    = azurerm_subnet.snet_aks.id
        workloadRuntime = "OCIContainer"
      }]
      apiServerAccessProfile = {
        disableRunCommand              = true
        # authorizedIpRanges             = null
        enablePrivateCluster           = false
        # enablePrivateClusterPublicFqdn = null
        enableVnetIntegration          = true
        # privateDnsZone                 = null
        subnetId                       = azurerm_subnet.snet_aks_apiserver.0.id
      }
      autoScalerProfile = {
        balance-similar-node-groups           = "false"
        daemonset-eviction-for-empty-nodes    = false
        daemonset-eviction-for-occupied-nodes = true
        expander                              = "random"
        ignore-daemonsets-utilization         = false
        max-empty-bulk-delete                 = "10"
        max-graceful-termination-sec          = "600"
        max-node-provision-time               = "15m"
        max-total-unready-percentage          = "45"
        new-pod-scale-up-delay                = "0s"
        ok-total-unready-count                = "3"
        scale-down-delay-after-add            = "10m"
        scale-down-delay-after-delete         = "10s"
        scale-down-delay-after-failure        = "3m"
        scale-down-unneeded-time              = "10m"
        scale-down-unready-time               = "20m"
        scale-down-utilization-threshold      = "0.5"
        scan-interval                         = "10s"
        skip-nodes-with-local-storage         = "false"
        skip-nodes-with-system-pods           = "true"
      }
      autoUpgradeProfile = {
        nodeOSUpgradeChannel = "NodeImage"
        upgradeChannel       = "node-image"
      }
      azureMonitorProfile = {
        metrics = {
          enabled          = false
          kubeStateMetrics = {}
        }
      }
      bootstrapProfile = {
        artifactSource = "Direct"
      }
      disableLocalAccounts = false
      dnsPrefix            = "aks"
      enableRBAC           = false
      # identityProfile = {
      #   kubeletidentity = {
      #     clientId   = "0b8d35ad-f32e-485c-be69-9e4d859d12dd"
      #     objectId   = "fcf4bb7d-08bf-4b92-9088-4d5d807a3329"
      #     resourceId = "/subscriptions/dcef7009-6b94-4382-afdc-17eb160d709a/resourcegroups/MC_rg-spoke-aks-simple_aks-cluster_swedencentral/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-cluster-agentpool"
      #   }
      # }
      kubernetesVersion = "1.32.4"
      metricsProfile = {
        costAnalysis = {
          enabled = false
        }
      }
      networkProfile = {
        dnsServiceIP    = "10.128.0.10"
        ipFamilies      = ["IPv4"]
        kubeProxyConfig = {}
        loadBalancerProfile = {
          backendPoolType = "nodeIPConfiguration"
          managedOutboundIPs = {
            count = 1
          }
        }
        loadBalancerSku    = "standard"
        networkDataplane   = "cilium"
        networkPlugin      = "azure"
        networkPluginMode  = "overlay"
        networkPolicy      = "cilium"
        outboundType       = "loadBalancer"
        podCidr            = "10.10.240.0/20"
        podCidrs           = ["10.10.240.0/20"]
        podLinkLocalAccess = "IMDS"
        serviceCidr        = "10.128.0.0/22"
        serviceCidrs       = ["10.128.0.0/22"]
      }
      oidcIssuerProfile = {
        enabled = false
      }
      securityProfile = {}
      servicePrincipalProfile = {
        clientId = "msi"
      }
      storageProfile = {
        diskCSIDriver = {
          enabled = true
          version = "v1"
        }
        fileCSIDriver = {
          enabled = true
        }
        snapshotController = {
          enabled = true
        }
      }
      supportPlan               = "KubernetesOfficial"
      workloadAutoScalerProfile = {}
    }
    sku = {
      name = "Base"
      tier = "Free"
    }
  }
}
