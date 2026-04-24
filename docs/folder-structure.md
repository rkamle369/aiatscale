# Folder Structure

Environments are top-level directories (`dev/`, `prod/`, and any others you add) next to `modules/`, so you do not need a `live/` layer.

```text
.
├── dev/
│   └── azure/
│       ├── env.hcl
│       └── terragrunt.hcl
├── prod/
│   └── azure/
│       ├── env.hcl
│       └── terragrunt.hcl
├── terragrunt.hcl
├── docs/
├── modules/
│   ├── azure/
│   │   ├── platform-network/
│   │   ├── aks-private/
│   │   ├── postgresql-flexible/
│   │   ├── acr/
│   │   ├── key-vault/
│   │   ├── resource-group/
│   │   ├── virtual-network/
│   │   └── subnet/
│   ├── aws/
│   └── gcp/
└── tfvars/
    ├── dev/azure/platform-network.tfvars
    └── prod/azure/platform-network.tfvars
```

## Design Notes

- Module-first structure for clean reuse.
- Terragrunt orchestrates environment-specific deployments; the root `terragrunt.hcl` is at the repository root and is included by all stacks.
- Single Terragrunt unit per environment for Azure network baseline.
- Explicit values over dynamic conditions for easier debugging.
