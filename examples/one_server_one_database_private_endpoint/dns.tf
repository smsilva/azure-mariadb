resource "azurerm_private_dns_zone" "default" {
  name                = "privatelink.mariadb.database.azure.com"
  resource_group_name = module.server.instance.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "wasp-link"
  resource_group_name   = module.server.instance.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = azurerm_virtual_network.default.id
}

resource "azurerm_private_endpoint" "default" {
  name                = "mariadb-${local.server_name}"
  location            = module.server.instance.location
  resource_group_name = module.server.instance.resource_group_name
  subnet_id           = azurerm_subnet.databases.id

  private_dns_zone_group {
    name                 = "${local.server_name}-privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.default.id]
  }

  private_service_connection {
    name                           = "${local.server_name}-privateserviceconnection"
    private_connection_resource_id = module.server.instance.id
    subresource_names              = ["mariadbServer"]
    is_manual_connection           = false
  }
}

locals {
  ttl_seconds = 60
}

resource "azurerm_private_dns_a_record" "default" {
  name                = local.server_name
  zone_name           = azurerm_private_dns_zone.default.name
  resource_group_name = module.server.instance.resource_group_name
  ttl                 = local.ttl_seconds

  records = [
    azurerm_private_endpoint.default.private_service_connection[0].private_ip_address
  ]
}
