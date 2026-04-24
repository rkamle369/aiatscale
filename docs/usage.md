# Usage Guide

## Prerequisites

- Terraform >= 1.5
- Terragrunt latest
- Azure authentication (for example `az login`)

## Deploy (single run per environment)

Each environment now has a **single Terragrunt unit** for Azure networking:

- `dev/azure`
- `prod/azure`

Run from one environment folder:

```bash
cd dev/azure
terragrunt init
terragrunt plan
terragrunt apply
```

## Variable Files

Each environment uses one dedicated tfvars file:

- `tfvars/dev/azure/platform-network.tfvars`
- `tfvars/prod/azure/platform-network.tfvars`

## Terraform State Layout

State files are separated by environment under the same Azure Blob container:

- `dev/azure/terraform.tfstate`
- `prod/azure/terraform.tfstate`

This gives one state file per environment for Azure network baseline.

The root Terragrunt config also generates an empty Terraform backend block (`backend "azurerm" {}`) in each stack so Terragrunt remote state works correctly in CI.

## GitHub Actions OIDC

This repository includes GitHub workflows for plan/apply using Azure Workload Identity (OIDC):

- `.github/workflows/terragrunt-plan.yml`
- `.github/workflows/terragrunt-apply.yml`

For Azure Portal setup and GitHub configuration steps, follow:

- `docs/github-actions-azure-workload-identity.md`
