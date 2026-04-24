name                = "vnet-prod-azure-spoke"
location            = "eastus"
resource_group_name = "rg-prod-azure-spoke"
address_space       = ["10.10.0.0/22"]
tags = {
  environment = "prod"
  network     = "spoke"
  managed_by  = "terraform"
}
