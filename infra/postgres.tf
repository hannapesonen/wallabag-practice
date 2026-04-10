resource "azurerm_postgresql_flexible_server" "db" {
  name = local.pg_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  administrator_login = "pgadmin"
  administrator_password = var.postgres_admin_password
  version = "16"

  storage_mb = "32768"
  sku_name = "B_Standard_B1ms"

  authentication {
    password_auth_enabled = true
  }

  public_network_access_enabled = true
}

resource "azurerm_postgresql_flexible_server_database" "wallabag_db" {
  name = "wallabag"
  server_id = azurerm_postgresql_flexible_server.db.id
  charset = "UTF8"
  collation = "en_us.utf8"
}