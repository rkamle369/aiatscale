name                = "vnet-dev-azure-hub"
location            = "eastus"
resource_group_name = "rg-dev-azure-hub"
address_space       = ["10.1.0.0/16"]
tags = {
  environment = "dev"
  network     = "hub"
  managed_by  = "terraform"
}
