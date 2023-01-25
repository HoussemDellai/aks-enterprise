resource "azurerm_resource_group" "rg_spoke_shared" {
  name     = "rg-spoke-shared"
  location = "westeurope"
}

resource "azurerm_mysql_server" "mysql" {
  name                = "mysqlserver01357"
  location            = azurerm_resource_group.rg_spoke_shared.location
  resource_group_name = azurerm_resource_group.rg_spoke_shared.name

  administrator_login          = "houssem"
  administrator_login_password = "@Aa123456789"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  lifecycle {
    ignore_changes = [
      threat_detection_policy
    ]
  }
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = "mysqldb"
  resource_group_name = azurerm_resource_group.rg_spoke_shared.name
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}