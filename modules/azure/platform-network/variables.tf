variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "hub_resource_group_name" {
  type = string
}

variable "hub_virtual_network_name" {
  type = string
}

variable "hub_address_space" {
  type = string
}

variable "hub_subnet_azurefirewall" {
  type = string
}

variable "hub_subnet_appgw" {
  type = string
}

variable "hub_subnet_bastion" {
  type = string
}

variable "spoke_resource_group_name" {
  type = string
}

variable "apps_resource_group_name" {
  type = string
}

variable "spoke_virtual_network_name" {
  type = string
}

variable "spoke_address_space" {
  type = string
}

variable "spoke_subnet_aks" {
  type = string
}

variable "spoke_subnet_db" {
  type = string
}

variable "spoke_subnet_private_endpoints" {
  type = string
}

variable "spoke_subnet_jump" {
  type = string
}
