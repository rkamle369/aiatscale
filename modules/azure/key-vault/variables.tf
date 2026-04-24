variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tenant_id" { type = string }
variable "public_network_access_enabled" { type = bool }
variable "purge_protection_enabled" { type = bool }
variable "tags" {
  type    = map(string)
  default = {}
}
