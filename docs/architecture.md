# Architecture Overview

## Goals

- Keep Terraform code modular and reusable.
- Keep environment configurations explicit and simple.
- Support Azure, AWS, and GCP from one repository.
- Use Terragrunt for environment orchestration and var-file wiring.

## Current Scope

Implemented Azure foundational network stack:

- Consolidated `platform-network` module (hub + spoke network baseline)
- Separate resource groups for:
  - hub network
  - spoke network
  - apps/services workload placement (for AKS and app resources)
- Backward-compatible foundational modules:
  - Resource Group module
  - Virtual Network module
  - Subnet module

## Environment Strategy

Each environment (for example `dev`, `prod`) has:

- A single Azure Terragrunt unit at repository root (`dev/azure`, `prod/azure`)
- One dedicated tfvars file under `tfvars/`
- A single Azure state file per environment

No complex condition trees are used; each environment is explicit.
