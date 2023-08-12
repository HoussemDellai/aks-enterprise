output "app_frontend_url" {
  value = azurerm_container_app.aca_frontend.latest_revision_fqdn
}