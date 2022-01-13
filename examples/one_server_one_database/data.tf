data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "http://httpbin.org/get"
}
