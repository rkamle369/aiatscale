data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "hub" {
  name     = var.hub_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = [var.hub_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "hub_azurefirewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_subnet_azurefirewall]
}

resource "azurerm_subnet" "hub_appgw" {
  name                 = "AppGatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_subnet_appgw]
}

resource "azurerm_subnet" "hub_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_subnet_bastion]
}

resource "azurerm_resource_group" "spoke" {
  name     = var.spoke_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "apps" {
  name     = var.apps_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = [var.spoke_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "spoke_aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke_subnet_aks]
}

resource "azurerm_user_assigned_identity" "kv_uami" {
  name                = var.aks_keyvault_uami_name
  resource_group_name = azurerm_resource_group.apps.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "terraform_subnet_network_contributor" {
  scope                = azurerm_subnet.spoke_aks.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_subnet" "spoke_db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke_subnet_db]

  delegation {
    name = "postgres-flexible-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet" "spoke_private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke_subnet_private_endpoints]
}

resource "azurerm_subnet" "spoke_jump" {
  name                 = "snet-jump"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke_subnet_jump]
}

module "acr" {
  source = "../acr"

  name                = var.acr_name
  resource_group_name = azurerm_resource_group.apps.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
  tags                = var.tags
}

module "key_vault" {
  source = "../key-vault"

  name                          = var.key_vault_name
  resource_group_name           = azurerm_resource_group.apps.name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = true
  purge_protection_enabled      = false
  tags                          = var.tags
}

resource "azurerm_role_assignment" "terraform_key_vault_secrets_officer" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

module "aks" {
  source = "../aks-private"

  name               = var.aks_name
  location           = var.location
  resource_group_name = azurerm_resource_group.apps.name
  node_resource_group_name = var.aks_node_resource_group_name
  dns_prefix         = var.aks_dns_prefix
  subnet_id          = azurerm_subnet.spoke_aks.id
  system_node_pool_name = var.aks_system_node_pool_name
  node_vm_size       = var.aks_node_vm_size
  node_count         = var.aks_node_count
  spot_node_pool_name = var.aks_spot_node_pool_name
  spot_node_vm_size  = var.aks_spot_node_vm_size
  spot_node_count    = var.aks_spot_node_count
  spot_max_price     = var.aks_spot_max_price
  istio_internal_ingress_enabled = var.aks_istio_internal_ingress_enabled
  istio_external_ingress_enabled = var.aks_istio_external_ingress_enabled
  tags               = var.tags

  depends_on = [
    azurerm_role_assignment.terraform_subnet_network_contributor
  ]
}

resource "azurerm_federated_identity_credential" "kv_workload" {
  for_each = {
    for b in var.aks_keyvault_workload_identity_bindings :
    "${b.namespace}/${b.service_account}" => b
  }

  # Stable short name (Azure name constraints); subject uniqueness is the map key.
  name                  = "fic-kv-${substr(md5(each.key), 0, 24)}"
  resource_group_name   = azurerm_resource_group.apps.name
  parent_id             = azurerm_user_assigned_identity.kv_uami.id
  issuer                = module.aks.oidc_issuer_url
  subject               = "system:serviceaccount:${each.value.namespace}:${each.value.service_account}"
  audience              = ["api://AzureADTokenExchange"]

  depends_on = [module.aks]
}

module "postgresql" {
  source = "../postgresql-flexible"

  name                  = var.postgresql_server_name
  resource_group_name   = azurerm_resource_group.apps.name
  location              = var.location
  postgresql_engine_version = var.postgresql_version
  delegated_subnet_id   = azurerm_subnet.spoke_db.id
  virtual_network_id    = azurerm_virtual_network.spoke.id
  private_dns_zone_name = var.postgresql_private_dns_zone_name
  private_dns_link_name = var.postgresql_private_dns_link_name
  administrator_login   = var.postgresql_admin_username
  storage_mb            = var.postgresql_storage_mb
  sku_name              = var.postgresql_sku_name
  zone                  = var.postgresql_zone
  tags                  = var.tags
}

resource "azurerm_key_vault_secret" "postgres_username" {
  name         = "postgres-admin-username"
  value        = module.postgresql.administrator_username
  key_vault_id = module.key_vault.id

  depends_on = [
    azurerm_role_assignment.terraform_key_vault_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-admin-password"
  value        = module.postgresql.administrator_password
  key_vault_id = module.key_vault.id

  depends_on = [
    azurerm_role_assignment.terraform_key_vault_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "postgres_url" {
  name         = "postgres-url"
  value        = "postgresql://${module.postgresql.fqdn}:5432/postgres"
  key_vault_id = module.key_vault.id

  depends_on = [
    azurerm_role_assignment.terraform_key_vault_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "postgres_secure_string" {
  name         = "postgres-secure-string"
  value        = "Host=${module.postgresql.fqdn};Port=5432;Database=postgres;Username=${module.postgresql.administrator_username};Password=${module.postgresql.administrator_password};Ssl Mode=Require"
  key_vault_id = module.key_vault.id

  depends_on = [
    azurerm_role_assignment.terraform_key_vault_secrets_officer
  ]
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_object_id
}

resource "azurerm_role_assignment" "aks_key_vault_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.kv_uami.principal_id
}
