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

output "key_vault_workload_identity_client_id" {
  value = azurerm_user_assigned_identity.kv_uami.client_id
}

output "key_vault_workload_identity_principal_id" {
  value = azurerm_user_assigned_identity.kv_uami.principal_id
}

output "key_vault_workload_identity_subjects" {
  description = "Kubernetes SA subjects that have federated credentials on the Key Vault UAMI"
  value = [
    for b in var.aks_keyvault_workload_identity_bindings :
    "system:serviceaccount:${b.namespace}:${b.service_account}"
  ]
}

output "postgresql_fqdn" {
  value = module.postgresql.fqdn
}
