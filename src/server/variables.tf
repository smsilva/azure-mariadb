variable "server_name" {
  type    = string
  default = "wasp-1"
}

variable "server_admin_username" {
  type    = string
  default = "sofia"
}

variable "keyvault" {
  type = object({
    name                = string
    resource_group_name = string
  })
}
