output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "apps_resource_group_name" {
  value = azurerm_resource_group.apps.name
}

output "aks_id" {
  value = module.aks.id
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "key_vault_name" {
  value = module.key_vault.name
}

output "postgresql_fqdn" {
  value = module.postgresql.fqdn
}
