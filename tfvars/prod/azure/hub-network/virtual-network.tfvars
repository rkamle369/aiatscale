name                = "vnet-prod-azure-hub"
location            = "eastus"
resource_group_name = "rg-prod-azure-hub"
address_space       = ["10.1.0.0/16"]
tags = {
  environment = "prod"
  network     = "hub"
  managed_by  = "terraform"
}
