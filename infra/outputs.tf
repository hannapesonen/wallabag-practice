output "container_app_url" {
  value = azurerm_container_app.wallabag.latest_revision_fqdn
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "postgres_hostname" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}