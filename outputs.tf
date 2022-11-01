output "rg_aks" {
  value = var.enable_aks_cluster ? var.rg_spoke_aks : null
}

output "rg_spoke_aks_nodes" {
  value = var.enable_aks_cluster ? var.rg_spoke_aks_nodes : null
}

output "client_key" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config.0.client_key : null
  sensitive = true
}

output "client_certificate" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config.0.client_certificate : null
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config.0.cluster_ca_certificate : null
  sensitive = true
}

output "cluster_username" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config.0.username : null
  sensitive = true
}

output "cluster_password" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config.0.password : null
  sensitive = true
}

output "kube_config" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config_raw : null
  sensitive = true
}

output "host" {
  value     = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.kube_config.0.host : null
  sensitive = true
}

output "app_gateway_ip_address" {
  value = var.enable_app_gateway ? azurerm_public_ip.appgw_pip.0.ip_address : null
}

output "nat_gateway_ip_address" {
  value = var.enable_aks_cluster && var.aks_outbound_type == "userAssignedNATGateway" ? azurerm_public_ip.natgw_pip.0.ip_address : null
}

output "private_dns_zone_aks_id" {
  value = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_zone_aks.0.id : null
}

output "private_dns_zone_aks_name" {
  value = var.enable_private_cluster ? azurerm_private_dns_zone.private_dns_zone_aks.0.name : null
}

output "aks_public_fqdn" {
  value = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.fqdn : null
}

output "aks_private_fqdn" {
  value = var.enable_aks_cluster && var.enable_private_cluster ? azurerm_kubernetes_cluster.aks.0.private_fqdn : null
}

output "aks_portal_fqdn" {
  value = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.portal_fqdn : null
}

output "aks_oidc_issuer_url" {
  value = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.oidc_issuer_url : null
}

# output "load_balancer_effective_outbound_ips" {
#   value = azurerm_kubernetes_cluster.aks.0.load_balancer_profile #.effective_outbound_ips
# }

# output "nat_gateway_effective_outbound_ips" {
#   value = azurerm_kubernetes_cluster.aks.0.nat_gateway_profile #.effective_outbound_ips
# }

output "aks_identity" {
  value = var.enable_aks_cluster ? azurerm_kubernetes_cluster.aks.0.identity.0.principal_id : null
}