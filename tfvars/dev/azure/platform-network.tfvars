location = "eastus"
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
