resource "azurerm_firewall_policy_rule_collection_group" "policy_group_aks" {
  count              = var.enable_route_traffic_to_firewall ? 1 : 0
  name               = "policy_group_aks"
  firewall_policy_id = data.terraform_remote_state.hub.0.outputs.firewall.policy_id # azurerm_firewall_policy.firewall_policy.id
  priority           = 200

  application_rule_collection {
    name     = "app-rules-private-aks"
    priority = 200
    action   = "Allow"

    rule {
      name             = "MicrosoftEntraAuthentication"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["login.microsoftonline.com"]
    }

    rule {
      name             = "MicrosoftContainerRegistry"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = [
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "mcr-0001.mcr-msedge.net"
      ]
    }

    rule {
      name             = "AzureAPI"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["management.azure.com"]
    }

    rule {
      name             = "MicrosoftPackagesRepository"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["packages.microsoft.com"]
    }

    rule {
      name             = "AKStoolsBinaries"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["acs-mirror.azureedge.net"]
    }

    rule {
      name             = "LinuxSecurityPatchAndUpdate"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 80
        type = "Http"
      }
      destination_fqdns = [
        "security.ubuntu.com",
        "azure.archive.ubuntu.com",
        "changelogs.ubuntu.com",
      ]
    }

    rule {
      name             = "LinuxSecurityPatchAndUpdateFromSnapshotService"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["snapshot.ubuntu.com"]
    }

    rule {
      name             = "AzurePolicy"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["data.policy.core.windows.net"]
    }

    rule {
      name             = "GatekeeperArtifactsAndPolicies"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["store.policy.core.windows.net"]
    }

    rule {
      name             = "AzurePolicyAddonSendsTelemetryToAppInsights"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = [
        "dc.services.visualstudio.com"
      ]
    }

    rule {
      name             = "AzureKeyVault"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["vault.azure.net"]
    }

    rule {
      name             = "AKSControlPlane"
      source_addresses = azurerm_subnet.snet_aks.address_prefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = ["*.${var.location}.azmk8s.io"]
    }
  }

  network_rule_collection {
    name     = "network-rules-private-aks"
    priority = 300
    action   = "Allow"

    rule {
      name                  = "SendMtericsAndLogsToAzureMonitor"
      source_addresses      = azurerm_subnet.snet_aks.address_prefixes
      protocols             = ["TCP"] # Any, TCP, UDP, ICMP
      destination_addresses = ["AzureMonitor"]
      destination_ports     = ["443"]
    }
  }
}
