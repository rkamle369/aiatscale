locals {
  location = "eastus"
}

remote_state {
  backend = "azurerm"

  config = {
    resource_group_name  = get_env("TFSTATE_RESOURCE_GROUP", "")
    storage_account_name = get_env("TFSTATE_STORAGE_ACCOUNT", "")
    container_name       = get_env("TFSTATE_CONTAINER", "")
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    use_oidc             = true
  }
}

generate "provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
terraform {
  required_version = ">= 1.5.0"
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
