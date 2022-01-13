variable "project" {
  type    = string
  default = "wasp"
}

variable "name" {
  type    = string
  default = "mariadb"
}

variable "server_name" {
  type    = string
  default = "server"
}

variable "server_admin_name" {
  type    = string
  default = "sofia"
}

variable "database_name" {
  type    = string
  default = "demo"
}

variable "keyvault" {
  type = object({
    name                = string
    resource_group_name = string
  })
}
