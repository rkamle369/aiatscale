variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "node_resource_group_name" { type = string }
variable "dns_prefix" { type = string }
variable "subnet_id" { type = string }
variable "system_node_pool_name" { type = string }
variable "node_vm_size" { type = string }
variable "node_count" { type = number }
variable "spot_node_pool_name" { type = string }
variable "spot_node_vm_size" { type = string }
variable "spot_node_count" { type = number }
variable "spot_max_price" { type = number }
variable "istio_internal_ingress_enabled" { type = bool }
variable "istio_external_ingress_enabled" { type = bool }
variable "tags" {
  type    = map(string)
  default = {}
}
