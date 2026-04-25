resource "azurerm_kubernetes_cluster" "this" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  node_resource_group     = var.node_resource_group_name
  dns_prefix              = var.dns_prefix
  private_cluster_enabled = true
  sku_tier                = "Free"

  default_node_pool {
    name           = var.system_node_pool_name
    vm_size        = var.node_vm_size
    node_count     = var.node_count
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  service_mesh_profile {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = var.istio_internal_ingress_enabled
    external_ingress_gateway_enabled = var.istio_external_ingress_enabled
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = var.spot_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.spot_node_vm_size
  node_count            = var.spot_node_count
  mode                  = "User"
  os_type               = "Linux"
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = var.spot_max_price

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  tags = var.tags
}
