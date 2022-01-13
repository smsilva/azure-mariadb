resource "azurerm_virtual_network" "default" {
  name                = "${local.server_name}-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = module.server.instance.location
  resource_group_name = module.server.instance.resource_group_name
}

resource "azurerm_subnet" "databases" {
  name                 = "databases"
  resource_group_name  = module.server.instance.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.10.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = module.server.instance.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.100.0.0/16"]

  enforce_private_link_endpoint_network_policies = true
}
