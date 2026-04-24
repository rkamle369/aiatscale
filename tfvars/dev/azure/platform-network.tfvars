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
aks_dns_prefix      = "aksdevuaen"
aks_kubernetes_version = "1.30.7"
aks_node_vm_size    = "Standard_D4s_v5"
aks_node_count      = 2

postgresql_server_name           = "psql-dev-uaen"
postgresql_version               = "14"
postgresql_private_dns_zone_name = "dev-uaen.postgres.database.azure.com"
postgresql_private_dns_link_name = "dev-uaen-postgres-link"
postgresql_admin_username        = "pgadmin"
postgresql_storage_mb            = 32768
postgresql_sku_name              = "B_Standard_B1ms"
postgresql_zone                  = "1"
