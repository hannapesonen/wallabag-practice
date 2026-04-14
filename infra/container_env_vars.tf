# Environment variables for PostgreSQL Flexible Server
locals {
  wallabag_env_full = [
    {
        name = "APP_ENV"
        value = "prod"
    },
    {
        name = "APP_SECRET"
        value = "placeholder"
    } ,
    {
        name = "DATABASE_DRIVER"
        value = "pdo_pgsql"
    },
    {
        name = "DATABASE_HOST"
        value = azurerm_postgresql_flexible_server.db.fqdn
    },
    {
        name = "DATABASE_PORT"
        value = "5432"
    },
    {
        name = "DATABASE_NAME"
        value = azurerm_postgresql_flexible_server_database.wallabag_db.name
    },
    {
        name = "DATABASE_USER"
        value = "${azurerm_postgresql_flexible_server.db.administrator_login}@${azurerm_postgresql_flexible_server.db.name}"
    },
    {
        name = "DATABASE_PASSWORD"
        secret_name = "db-password"
    },
    {
        name = "DATABASE_SSLMODE"
        value = "require"
    },
    {
        name  = "SYMFONY__ENV__DOMAIN_NAME"
        value = "https://wallabag-app.ashycliff-1af91a32.northeurope.azurecontainerapps.io"
    },
    {
        name = "SERVER_NAME"
        value = "wallabag-app.ashycliff-1af91a32.northeurope.azurecontainerapps.io"
    },
    {
        name = "REVISION_BUMP"
        value = timestamp()
    }
  ]
}