locals {
  location = "eastus"
  # First folder in stack path (for example: dev or prod)
  environment = split("/", path_relative_to_include())[0]
}

remote_state {
  backend = "azurerm"

  config = {
    resource_group_name  = get_env("TFSTATE_RESOURCE_GROUP", "")
    storage_account_name = get_env("TFSTATE_STORAGE_ACCOUNT", "")
    container_name       = get_env("TFSTATE_CONTAINER", "")
    # State key is environment-prefixed so dev/prod are always separated
    # in the same container. Example:
    # - dev/azure/hub-network/resource-group/terraform.tfstate
    # - prod/azure/hub-network/resource-group/terraform.tfstate
    key                  = "${local.environment}/${trimprefix(path_relative_to_include(), "${local.environment}/")}/terraform.tfstate"
    use_oidc             = true
  }
}

generate "provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}
EOT
}
