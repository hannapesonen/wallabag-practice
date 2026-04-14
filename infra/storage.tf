resource "azurerm_storage_account" "wallabag_sa" {
  name = "${var.project_name}sa"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "wallabag_share" {
  name = "wallabagdata"
  storage_account_name = azurerm_storage_account.wallabag_sa.name
  quota = 50
}