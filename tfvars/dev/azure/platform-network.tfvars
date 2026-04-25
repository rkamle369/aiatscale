location = "uaenorth"
tags = {
  environment = "dev"
  managed_by  = "terraform"
}

hub_resource_group_name  = "rg-dev-hub-vnet"
hub_virtual_network_name = "vnet-dev-hub-vnet"
hub_address_space        = "10.1.0.0/16"
hub_subnet_azurefirewall = "10.1.1.0/24"
hub_subnet_appgw         = "10.1.2.0/24"
hub_subnet_bastion       = "10.1.3.0/24"

spoke_resource_group_name  = "rg-dev-spoke-vnet-devops"
apps_resource_group_name   = "rg-dev-apps-uaen"
spoke_virtual_network_name = "vnet-dev-spoke-vnet-devops"
spoke_address_space        = "10.10.0.0/22"
spoke_subnet_aks           = "10.10.1.0/25"
spoke_subnet_db            = "10.10.1.128/26"
spoke_subnet_private_endpoints = "10.10.1.192/26"
spoke_subnet_jump          = "10.10.2.0/26"

acr_name            = "acrdevuaen01"
key_vault_name      = "kv-dev-apps-uaen"
aks_name            = "aks-dev-uaen-private"
aks_node_resource_group_name = "rg-dev-apps-uaen-aks-nodes"
aks_keyvault_uami_name = "id-aks-dev-keyvault"
aks_keyvault_federated_credential_name = "fic-istio-keyvault-sa"
aks_keyvault_service_account_subject = "system:serviceaccount:istio-system:istio-keyvault-sa"
aks_dns_prefix      = "aksdevuaen"
aks_system_node_pool_name = "system"
aks_node_vm_size    = "Standard_D2s_v5"
aks_node_count      = 2
aks_spot_node_pool_name = "spotpool"
aks_spot_node_vm_size = "Standard_D2s_v5"
aks_spot_node_count   = 1
aks_spot_max_price    = -1
aks_istio_internal_ingress_enabled = true
aks_istio_external_ingress_enabled = true

postgresql_server_name           = "psql-dev-uaen"
postgresql_version               = "14"
postgresql_private_dns_zone_name = "dev-uaen.postgres.database.azure.com"
postgresql_private_dns_link_name = "dev-uaen-postgres-link"
postgresql_admin_username        = "pgadmin"
postgresql_storage_mb            = 32768
postgresql_sku_name              = "B_Standard_B1ms"
postgresql_zone                  = "1"
