# Folder Structure

Environments are top-level directories (`dev/`, `prod/`, and any others you add) next to `modules/`, so you do not need a `live/` layer.

```text
.
├── dev/
│   └── azure/
│       ├── env.hcl
│       ├── hub-network/
│       └── spoke-network/
├── prod/
│   └── azure/
│       ├── env.hcl
│       ├── hub-network/
│       └── spoke-network/
├── terragrunt.hcl
├── docs/
├── modules/
│   ├── azure/
│   │   ├── resource-group/
│   │   ├── virtual-network/
│   │   └── subnet/
│   ├── aws/
│   └── gcp/
└── tfvars/
    ├── dev/azure/
    └── prod/azure/
```

## Design Notes

- Module-first structure for clean reuse.
- Terragrunt orchestrates environment-specific deployments; the root `terragrunt.hcl` is at the repository root and is included by all stacks.
- Dedicated tfvars files per component and environment.
- Explicit values over dynamic conditions for easier debugging.

## Why not `live/`?

Some teams use a `live/` (or `environments/`) folder only to separate "deployed stacks" from `modules/`. This repo instead keeps `dev/`, `prod/`, and future envs at the root for shorter paths and less nesting.
