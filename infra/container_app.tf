resource "azurerm_container_app_environment" "env" {
  name = local.cae_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "wallabag" {
  name = local.app_name
  resource_group_name = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode = "Single"

  template {
    container {
        name = "wallabag"
        image = "${azurerm_container_registry.acr.login_server}/${var.project_name}:latest"
        cpu = 0.5
        memory = "1Gi"

        dynamic "env" {
          for_each = local.wallabag_env_full
          content {
            name = env.value.name
            value = env.value.name
          }
        }

        env {
            name = "SYMFONY__ENV__DATABASE_PASSWORD"
            secret_name = "acr-password"
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
