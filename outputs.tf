output "rg_aks" {
  value = var.rg_aks
}

output "rg_aks_nodes" {
  value = var.rg_aks_nodes
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_username" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.username
  sensitive = true
}

output "cluster_password" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.password
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.host
  sensitive = true
}

output "app_gateway_ip_address" {
  value = var.enable_application_gateway ? azurerm_public_ip.appgw_pip.0.ip_address : "Application Gateway is disabled"
}

output "nat_gateway_ip_address" {
  value = var.aks_outbound_type == "userAssignedNATGateway" ? azurerm_public_ip.natgw_pip.0.ip_address : "NAT Gateway is disabled"
}

output "aks_private_zone_id" {
  value = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_aks.0.id : "Private cluster is disabled"
}

output "aks_private_zone_name" {
  value = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_aks.0.name : "Private cluster is disabled"
}

output "aks_public_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_portal_fqdn" {
  value = azurerm_kubernetes_cluster.aks.portal_fqdn
}

output "aks_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

# output "load_balancer_effective_outbound_ips" {
#   value = azurerm_kubernetes_cluster.aks.load_balancer_profile #.effective_outbound_ips
# }

# output "nat_gateway_effective_outbound_ips" {
#   value = azurerm_kubernetes_cluster.aks.nat_gateway_profile #.effective_outbound_ips
# }

output "aks_identity" {
  value = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}