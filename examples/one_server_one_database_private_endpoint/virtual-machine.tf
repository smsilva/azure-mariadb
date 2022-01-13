resource "azurerm_public_ip" "mariadb_client" {
  name                = "pip_mariadb_client"
  allocation_method   = "Dynamic"
  location            = module.server.instance.location
  resource_group_name = module.server.instance.resource_group_name

  depends_on = [
    module.server
  ]
}

resource "azurerm_network_interface" "mariadb_client" {
  name                = "mariadb-client"
  location            = module.server.instance.location
  resource_group_name = module.server.instance.resource_group_name

  ip_configuration {
    name                          = "mariadb_client_config"
    subnet_id                     = azurerm_subnet.databases.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mariadb_client.id
  }
}

resource "azurerm_linux_virtual_machine" "mariadb_client" {
  name                = "mariadb-client"
  location            = module.server.instance.location
  resource_group_name = module.server.instance.resource_group_name
  size                = "Standard_F2"
  admin_username      = "silvios"

  network_interface_ids = [
    azurerm_network_interface.mariadb_client.id,
  ]

  admin_ssh_key {
    username   = "silvios"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
