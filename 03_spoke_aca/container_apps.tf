resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "workspace-aca"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "aca_environment" {
  name                       = "aca-environment"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
}

resource "azurerm_container_app" "aca_backend" {
  name                         = "aca-app-backend-api"
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend-api"
      image  = "ghcr.io/houssemdellai/containerapps-album-backend:v1"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = false # true
    target_port                = 3500
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "aca_frontend" {
  name                         = "aca-app-frontend-ui"
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend-ui"
      image  = "ghcr.io/houssemdellai/containerapps-album-frontend:v1"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "API_BASE_URL"
        value = "https://${azurerm_container_app.aca_backend.latest_revision_fqdn}"
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 3000
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }

    custom_domain {
      certificate_binding_type = "SniEnabled"                                                 # "SniEnabled" (Optional) Defaults to Disabled
      certificate_id           = azurerm_container_app_environment_certificate.certificate.id # (Required) The ID of the Container App Environment Certificate
      name                     = "aca-app.apps.houssem15.com"                                 # (Required) The hostname of the Certificate. Must be the CN or a named SAN in the certificate.
    }
  }
}

resource "azurerm_container_app_environment_certificate" "certificate" {
  name                         = "aca-certificate"
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  certificate_blob_base64      = acme_certificate.certificate.certificate_p12 # tls_self_signed_cert.tls_cert.cert_pem # filebase64("path/to/certificate_file.pfx")
  certificate_password         = "@Aa123456789"                               # (Required) The password for the Certificate. Changing this forces a new resource to be created.
}
