# Environment variables for PostgreSQL Flexible Server
locals {
  wallabag_env_full = concat(
    local.wallabag_env,
    [
        {
            name = "SYMFONY__ENV__DATABASE_HOST"
            value = azurerm_postgresql_flexible_server.db.fqdn
        },
        {
            name = "SYMFONY__ENV__DATABASE_NAME"
            value = azurerm_postgresql_flexible_server_database.wallabag_db.name
        },
        {
            name = "SYMFONY__ENV__DATABASE_USER"
            value = "${azurerm_postgresql_flexible_server.db.administrator_login}@${azurerm_postgresql_flexible_server.db.name}"
        }
    ]
  )
}