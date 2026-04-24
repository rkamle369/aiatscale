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

variable "acr_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "aks_kubernetes_version" {
  type = string
}

variable "aks_node_vm_size" {
  type = string
}

variable "aks_node_count" {
  type = number
}

variable "postgresql_server_name" {
  type = string
}

variable "postgresql_version" {
  type = string
}

variable "postgresql_private_dns_zone_name" {
  type = string
}

variable "postgresql_private_dns_link_name" {
  type = string
}

variable "postgresql_admin_username" {
  type = string
}

variable "postgresql_storage_mb" {
  type = number
}

variable "postgresql_sku_name" {
  type = string
}

variable "postgresql_zone" {
  type = string
}
