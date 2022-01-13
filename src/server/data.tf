data "azurerm_key_vault" "default" {
  name                = var.keyvault.name
  resource_group_name = var.keyvault.resource_group_name
}

data "azurerm_resource_group" "default" {
  name = var.keyvault.resource_group_name
}
