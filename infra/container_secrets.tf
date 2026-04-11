# Azure Container App secret definitions
resource "azurerm_container_app_secret" "acr_password" {
  name = "acr-password"
  container_appd_id = azurerm_container_app.wallabag.id
  value = azurerm_container_registry.acr.admin_password
}