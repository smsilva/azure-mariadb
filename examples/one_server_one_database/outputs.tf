output "http_result" {
  value = jsondecode(data.http.ip.body).origin
}

output "client_config" {
  value = data.azurerm_client_config.current
}

output "server_instance_id" {
  value = module.server.instance.id
}

output "server_instance_fqdn" {
  value = module.server.instance.fqdn
}

output "server_instance" {
  value     = module.server.instance
  sensitive = true
}
