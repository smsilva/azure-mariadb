data "azurerm_key_vault" "default" {
  name                = var.keyvault.name
  resource_group_name = var.keyvault.resource_group_name
}

resource "azurerm_resource_group" "default" {
  name     = local.resource_group_name
  location = "eastus2"
}

resource "random_password" "mariadb_server_administrator" {
  length           = 16
  special          = true
  override_special = "_%@"
}

locals {
  server_admin_name       = var.server_admin_name
  server_name             = "${var.project}-${var.name}-${var.server_name}"
  resource_group_name     = local.server_name
  server_admin_key_secret = "${local.server_name}-${local.server_admin_name}"
  database_name           = "${var.project}_${var.name}_${var.server_name}_${var.database_name}"
}

resource "azurerm_key_vault_secret" "default" {
  name         = local.server_admin_key_secret
  value        = random_password.mariadb_server_administrator.result
  key_vault_id = data.azurerm_key_vault.default.id
}

resource "azurerm_mariadb_server" "default" {
  name                = local.server_name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = local.server_admin_name
  administrator_login_password = random_password.mariadb_server_administrator.result

  version                 = "10.2"
  ssl_enforcement_enabled = true
}

resource "azurerm_mariadb_database" "default" {
  name                = local.database_name
  resource_group_name = azurerm_resource_group.default.name
  server_name         = azurerm_mariadb_server.default.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

output "server_id" {
  value = azurerm_mariadb_server.default.id
}

output "server_instance" {
  value     = azurerm_mariadb_server.default
  sensitive = true
}

output "database_id" {
  value = azurerm_mariadb_database.default.id
}
