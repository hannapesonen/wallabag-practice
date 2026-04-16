resource "azurerm_container_app_environment" "env" {
  name = local.cae_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azapi_resource" "env_storage" {
  type = "Microsoft.App/managedEnvironments/storages@2022-03-01"
  name = "wallabagfiles"
  parent_id = azurerm_container_app_environment.env.id

  body = {
    properties = {
      azureFile = {
        accountName = azurerm_storage_account.wallabag_sa.name
        accountKey = azurerm_storage_account.wallabag_sa.primary_access_key
        shareName = azurerm_storage_share.wallabag_share.name
        accessMode = "ReadWrite"
      }
    }
  }

  schema_validation_enabled = false
}

resource "azurerm_container_app" "wallabag" {
  name = local.app_name
  resource_group_name = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode = "Single"

  secret {
    name = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }

  secret {
    name = "db-password"
    value = azurerm_postgresql_flexible_server.db.administrator_password
  }

  secret {
    name = "storage-key"
    value = azurerm_storage_account.wallabag_sa.primary_access_key
  }

  template {
    volume {
      name = "wallabagdata"
      storage_type = "AzureFile"
      storage_name = azapi_resource.env_storage.name
    }

    container {
        name = "wallabag"
        image = "${azurerm_container_registry.acr.login_server}/${var.project_name}:${var.wallabag_image_tag}"
        cpu = 0.5
        memory = "1Gi"

        volume_mounts {
          name = "wallabagdata"
          path = "/var/www/wallabag/db-data"
        }

        dynamic "env" {
          for_each = local.wallabag_env_full
          content {
            name = env.value.name
            value = lookup(env.value, "value", null)
            secret_name = lookup(env.value, "secret_name", null)
          }
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
