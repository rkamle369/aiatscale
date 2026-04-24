# Terraform + Terragrunt Multi-Cloud Module Infrastructure

This repository provides a **module-based infrastructure baseline** using:

- Terraform modules (`modules/`)
- Terragrunt per-environment stacks at repo root (`dev/`, `prod/`, and more as needed)
- Dedicated environment tfvars (`tfvars/`)
- Documentation (`docs/`)

Current implementation includes Azure foundation modules and environment stacks for:

- Resource Groups
- Virtual Networks
- Subnets

The layout is designed to support multiple clouds in the same repository:

- Azure
- AWS
- GCP

## Quick Start

1. Install Terraform and Terragrunt.
2. Configure Azure credentials.
3. Go to an environment stack directory, for example:
   - `dev/azure/hub-network/resource-group` (or another component under `dev/azure/...` or `prod/azure/...`)
4. Run:

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

## Documentation

See the `docs/` folder:

- `docs/architecture.md`
- `docs/folder-structure.md`
- `docs/azure-network-design.md`
- `docs/usage.md`
- `docs/github-actions-azure-workload-identity.md`
