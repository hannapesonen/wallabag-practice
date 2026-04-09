resource "azurerm_resource_group" "rg" {
  name = "${var.project_name}-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name = "${var.project_name}acrwallabag"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku = "Basic"
  admin_enabled = true
}

resource "azurerm_postgresql_flexible_server" "postgresql" {
  name = "${var.project_name}-pg"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  administrator_login = "pgadmin"
  administrator_password = var.postgres_admin_password
  version = "16"
  
  storage_mb = "32768"
  sku_name = "B_Standard_B1ms"

  backup_retention_days = "7"
  geo_redundant_backup_enabled = false

  high_availability {
    mode = "Disabled"
  }

  authentication {
    password_auth_enabled = true
  }

  public_network_access_enabled = true # change once deployed
}

resource "azurerm_postgresql_flexible_server_database" "wallabag_db" {
  name = "wallabag-db"
  server_id = azurerm_postgresql_flexible_server.db.server_id
  charset = "UTF8"
  collation = "en_us.utf8"
}

resource "azurerm_container_app_environment" "env" {
  name = "${var.project_name}-cae"
  location = azurerm_resource_group.rg.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "wallabag" {
  name = "${var.project_name}-app"
  resource_group_name = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode = "Single"

  secret {
    name = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }

template {
  container {
    name = "wallabag"
    image = "${azure_container_registry.acr.login_server}/${var.project_name}:latest"
    cpu = 0.5
    memory = "1Gi"

    env {
        name = "SYMFONY__ENV__DATABASE_DRIVER"
        value = "pdo_pgsql"
    }

    env {
        name = "SYMFONY__ENV__DATABASE_HOST"
        value = azurerm_postgresql_flexible_server.db.fqdn
    }

    env {
        name = "SYMFONY__ENV__DATABASE_PORT"
        value = "5432"
    }

    env {
        name = "SYMFONY__ENV__DATABASE_NAME"
        value = azurerm_postgresql_flexible_server_database.wallabag_db.name
    }

    env {
        name = "SYMFONY__ENV__DATABASE_USER"
        value = "${azurerm_postgresql_flexible_server.db.administrator_login}@${azurerm_postgresql_flexible_server.db.name}"
    }

    env {
        name = "SYMFONY__ENV__DATABASE_PASSWORD"
        secret_name = "acr-password"
    }

    env {
        name = "SYMFONY__ENV__DOMAIN_NAME"
        value = "https://example.com" # adjust later
    }
  }

    min_replicas = 1
    max_replicas = 1
  }

ingress {
    external_enabled = true
    target_port = 80

    traffic_weight {
        percentage = 100
        latest_revision = true
    }
}

registry {
  server = azurerm_container_registry.acr.login_server
  username = azurerm_container_registry.acr.admin_username
  password_secret_name = "acr-password"
  }
}

