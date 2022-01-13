locals {
  server_name  = "wasp-telemetry"
  cluster_name = local.server_name
}

module "server" {
  source = "../../src/server"

  server_name           = local.server_name
  server_admin_username = "silvios"

  keyvault = {
    name                = "waspfoundation636a465c",
    resource_group_name = "wasp-foundation"
  }
}
