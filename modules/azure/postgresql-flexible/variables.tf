variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "version" { type = string }
variable "delegated_subnet_id" { type = string }
variable "virtual_network_id" { type = string }
variable "private_dns_zone_name" { type = string }
variable "private_dns_link_name" { type = string }
variable "administrator_login" { type = string }
variable "storage_mb" { type = number }
variable "sku_name" { type = string }
variable "zone" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
