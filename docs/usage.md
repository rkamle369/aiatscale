# Usage Guide

## Prerequisites

- Terraform >= 1.5
- Terragrunt latest
- Azure authentication (for example `az login`)

## Deploy (single run per environment)

Each environment now has a **single Terragrunt unit** for Azure platform resources:

- `dev/azure`
- `prod/azure`

Terragrunt uses `modules/azure//platform-network` as source so sibling reusable modules (`acr`, `aks-private`, `key-vault`, `postgresql-flexible`) are available in cache during CI runs.

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

This gives one state file per environment for Azure platform baseline.

## Dev workload additions

The dev environment (`tfvars/dev/azure/platform-network.tfvars`) now includes:

- Private AKS cluster (2 nodes, `Standard_D4s_v5` ~= 16 GiB RAM/node)
- Istio service mesh with internal ingress gateway enabled
- Azure Container Registry (Standard SKU)
- Azure Key Vault (RBAC enabled)
- PostgreSQL Flexible Server (private access only) in spoke DB subnet

AKS integration is configured with:

- `AcrPull` role assignment on ACR to AKS kubelet identity
- `Key Vault Secrets User` role assignment on Key Vault to AKS kubelet identity

The root Terragrunt config also generates an empty Terraform backend block (`backend "azurerm" {}`) in each stack so Terragrunt remote state works correctly in CI.

## GitHub Actions OIDC

This repository includes GitHub workflows for plan/apply using Azure Workload Identity (OIDC):

- `.github/workflows/terragrunt-plan.yml`
- `.github/workflows/terragrunt-apply.yml`

For Azure Portal setup and GitHub configuration steps, follow:

- `docs/github-actions-azure-workload-identity.md`
