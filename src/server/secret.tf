resource "random_password" "mariadb_server_administrator" {
  length           = 16
  special          = true
  override_special = "_%@"
}

locals {
  server_admin_key_secret = "${var.server_name}-admin"
}

resource "azurerm_key_vault_secret" "admin_name" {
  name         = "${var.server_name}-admin-name"
  value        = var.server_admin_username
  key_vault_id = data.azurerm_key_vault.default.id
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "${var.server_name}-admin-password"
  value        = random_password.mariadb_server_administrator.result
  key_vault_id = data.azurerm_key_vault.default.id
}
