name                = "vnet-dev-azure-spoke"
location            = "eastus"
resource_group_name = "rg-dev-azure-spoke"
address_space       = ["10.10.0.0/22"]
tags = {
  environment = "dev"
  network     = "spoke"
  managed_by  = "terraform"
}
