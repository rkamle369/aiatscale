# Usage Guide

## Prerequisites

- Terraform >= 1.5
- Terragrunt latest
- Azure authentication (for example `az login`)

## Deploy Order (per env)

Replace `<env>` with the environment name at repo root, for example `dev` or `prod`.

Deploy hub:

1. `<env>/azure/hub-network/resource-group`
2. `<env>/azure/hub-network/virtual-network`
3. `<env>/azure/hub-network/subnet-azurefirewall`
4. `<env>/azure/hub-network/subnet-appgw`
5. `<env>/azure/hub-network/subnet-bastion`

Deploy spoke:

1. `<env>/azure/spoke-network/resource-group`
2. `<env>/azure/spoke-network/virtual-network`
3. `<env>/azure/spoke-network/subnet-aks`
4. `<env>/azure/spoke-network/subnet-db`
5. `<env>/azure/spoke-network/subnet-private-endpoints`
6. `<env>/azure/spoke-network/subnet-jump`

For each folder:

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

## Variable Files

Each component reads from a dedicated tfvars file in `tfvars/<env>/azure/...` via Terragrunt `extra_arguments`.

## GitHub Actions OIDC

This repository includes GitHub workflows for plan/apply using Azure Workload Identity (OIDC):

- `.github/workflows/terragrunt-plan.yml`
- `.github/workflows/terragrunt-apply.yml`

For Azure Portal setup and GitHub configuration steps, follow:

- `docs/github-actions-azure-workload-identity.md`
