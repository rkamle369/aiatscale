variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "dns_prefix" { type = string }
variable "subnet_id" { type = string }
variable "node_vm_size" { type = string }
variable "node_count" { type = number }
variable "spot_node_vm_size" { type = string }
variable "spot_node_count" { type = number }
variable "spot_max_price" { type = number }
variable "tags" {
  type    = map(string)
  default = {}
}
