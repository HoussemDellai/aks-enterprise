output "resource_group_name" {
  value = var.resource_group_name
}

# output "client_key" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
#   sensitive = true
# }

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
#   sensitive = true
# }

# output "cluster_ca_certificate" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
#   sensitive = true
# }

# output "cluster_username" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.username
#   sensitive = true
# }

# output "cluster_password" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.password
#   sensitive = true
# }

# output "host" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config.0.host
#   sensitive = true
# }

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "application_ip_address" {
  value = var.enable_application_gateway ? azurerm_public_ip.pip.0.ip_address : "Application Gateway is disabled"
}

output "aks_private_zone_id" {
  value = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_aks.0.id : "Private cluster is disabled"
}

output "aks_private_zone_name" {
  value = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_aks.0.name : "Private cluster is disabled"
}