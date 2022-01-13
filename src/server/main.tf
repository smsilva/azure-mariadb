resource "azurerm_mariadb_server" "default" {
  name                = var.server_name
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name

  sku_name = "GP_Gen5_2" # az mariadb server list-skus --location eastus2 --output table

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = var.server_admin_username
  administrator_login_password = random_password.mariadb_server_administrator.result

  version                 = "10.2"
  ssl_enforcement_enabled = true
}
 