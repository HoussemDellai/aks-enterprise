# https://github.com/claranet/terraform-azurerm-acr/blob/master/resources.tf

resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.rg_spoke_app.name
  location                      = var.resources_location
  sku                           = var.enable_private_acr ? "Premium" : "Standard"
  admin_enabled                 = false
  public_network_access_enabled = true
  zone_redundancy_enabled       = false
  anonymous_pull_enabled        = false
  data_endpoint_enabled         = false
  network_rule_bypass_option    = "AzureServices"
  tags                          = var.tags

  dynamic "network_rule_set" {
    for_each = var.enable_private_acr ? ["any_value"] : []
    content {
      default_action = "Deny"

      ip_rule {
        action   = "Allow"
        ip_range = "${data.http.machine_ip.response_body}/32"
      }
    }
  }

  # network_rule_set {
  #   default_action = "Deny"

  #   ip_rule {
  #     action   = "Allow"
  #     ip_range = "${data.http.machine_ip.response_body}/32"
  #   }

  #   # virtual_network {
  #   #   action    = "Allow"
  #   #   subnet_id = null
  #   # }
  # }
  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [
  #     azurerm_user_assigned_identity.container_registry_identity.id
  #   ]
  # }

  # georeplications {
  #   location                = "East US"
  #   zone_redundancy_enabled = true
  #   regional_endpoint_enabled = false
  #   tags                    = {}
  # }
  # georeplications {
  #   location                = "North Europe"
  #   zone_redundancy_enabled = true
  #   tags                    = {}
  # }

  provisioner "local-exec" {
    # interpreter = ["PowerShell", "-Command"]
    command = "az acr import --name ${azurerm_container_registry.acr.login_server} --source docker.io/library/hello-world:latest --image hello-world:latest"
    when    = create
  }
}

# resource "null_resource" "acr_import_image" {
#   # Changes to any instance of the cluster requires re-provisioning
#   # triggers = {
#   #   cluster_instance_ids = join(",", aws_instance.cluster.*.id)
#   # }
#   provisioner "local-exec" {
#     # interpreter = ["PowerShell", "-Command"]
#     command = "az acr import --name ${azurerm_container_registry.acr.login_server} --source docker.io/library/hello-world:latest --image hello-world:latest"
#     # Bootstrap script called with private_ip of each node in the clutser
#     # inline = [
#     #   "bootstrap-cluster.sh ${join(" ", aws_instance.cluster.*.private_ip)}",
#     # ]
#   }
#   depends_on = [azurerm_container_registry.acr]
# }

resource "azurerm_user_assigned_identity" "identity-kubelet" {
  count               = var.enable_aks_cluster ? 1 : 0
  name                = "identity-kubelet"
  resource_group_name = azurerm_resource_group.rg_spoke_aks.name # azurerm_kubernetes_cluster.aks.0.node_resource_group
  location            = var.resources_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "role_acrpull" {
  count                            = var.enable_aks_cluster ? 1 : 0
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.identity-kubelet.0.principal_id
  skip_service_principal_aad_check = true
}