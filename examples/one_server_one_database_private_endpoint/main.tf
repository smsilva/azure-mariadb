locals {
  server_name  = "wasp-sandbox-1"
  cluster_name = local.server_name
}

module "server" {
  source = "../../src/server"

  server_name           = local.server_name
  server_admin_username = "sofia"

  keyvault = {
    name                = "waspfoundation636a465c",
    resource_group_name = "wasp-foundation"
  }
}

# module "aks" {
#   source = "git@github.com:smsilva/azure-kubernetes.git//src?ref=3.0.0"

#   cluster_name            = local.cluster_name
#   cluster_location        = module.server.instance.location
#   cluster_version         = "1.21.7"
#   cluster_subnet_id       = azurerm_subnet.aks.id
#   cluster_admin_group_ids = ["d5075d0a-3704-4ed9-ad62-dc8068c7d0e1"]
#   default_node_pool_name  = "sysnp01" # 12 Alphanumeric characters
#   resource_group_name     = module.server.instance.resource_group_name

#   depends_on = [
#     module.server
#   ]
# }
