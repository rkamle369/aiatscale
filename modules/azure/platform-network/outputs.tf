output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "apps_resource_group_name" {
  value = azurerm_resource_group.apps.name
}
